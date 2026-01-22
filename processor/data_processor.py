import pandas as pd
import numpy as np
from database.db_connector import get_connection
from processor.conf import SALARY_INDICATORS, ANALYSIS_CONFIG, PRODUCT_LIST, TARGET_COUNTRIES

class DataEngine:
    def __init__(self):
        self.conn = get_connection()

    def __del__(self):
        if hasattr(self, 'conn') and self.conn:
            self.conn.close()

class EconomicProcessor(DataEngine):
    def __init__(self):
        super().__init__()

    def _get_latest_salaries(self, country_id):
        """Busca salários e converte mensal para hora usando as estatísticas do país"""
        # 1. Busca os salários (Mensais e Horas se existirem)
        query_salary = """
            SELECT DISTINCT ON (id_indicator) id_indicator, salary_value
            FROM salary_history
            WHERE id_country = %s
            ORDER BY id_indicator, reference_year DESC
        """
        df_sal = pd.read_sql(query_salary, self.conn, params=(country_id,))
        if df_sal.empty:
            return None
        
        # 2. Busca a média de horas trabalhadas semanalmente
        query_hours = """
            SELECT value FROM country_stats 
            WHERE id_country = %s AND id_indicator = 5 -- ID 5 é QLS_HW_AVE_NB_A
            ORDER BY year DESC LIMIT 1
        """
        res_hours = pd.read_sql(query_hours, self.conn, params=(country_id,))
        avg_weekly_hours = float(res_hours['value'].iloc[0]) if not res_hours.empty else 40.0 # Default caso falhe
        
        # Mapeia os salários atuais
        raw_salaries = df_sal.set_index('id_indicator')['salary_value'].to_dict()
        
        # IDs que definimos anteriormente no SQL:
        # 1: Média Mensal, 2: Média Hora, 3: Mínimo Mensal, 4: Mínimo Hora
        
        processed = {}
        
        # --- Lógica de Cálculo Salário HORA ---
        
        # A. MÉDIA HORA (Prioriza o dado direto da OIT, se não tiver, calcula)
        if 2 in raw_salaries:
            processed['avg_hour'] = float(raw_salaries[2])
        elif 1 in raw_salaries:
            # Cálculo: Mensal / (Horas Semanais * 4.33 semanas/mês)
            processed['avg_hour'] = float(raw_salaries[1]) / (avg_weekly_hours * 4.33)
            
        # B. MÍNIMO HORA (Prioriza o dado direto da OIT, se não tiver, calcula)
        if 4 in raw_salaries:
            processed['min_hour'] = float(raw_salaries[4])
        elif 3 in raw_salaries:
            # Cálculo do salário mínimo por hora
            processed['min_hour'] = float(raw_salaries[3]) / (avg_weekly_hours * 4.33)

        return processed

    def _get_price_history(self, country_id, sku):
        query = """
            SELECT price_value, reference_date as collection_date 
            FROM price_history
            WHERE id_country = %s AND sku = %s
            ORDER BY reference_date DESC
            LIMIT 4
        """
        return pd.read_sql(query, self.conn, params=(country_id, sku))

    def _process_price_metrics(self, df_prices):
        if df_prices.empty: return None
        prices = df_prices['price_value'].astype(float)
        current_price = prices.iloc[0]
        avg_price = prices.mean()
        variation = abs((current_price - avg_price) / avg_price) if avg_price > 0 else 0
        
        return {
            "current": current_price,
            "avg_4w": round(float(avg_price), 2),
            "is_outlier": variation > ANALYSIS_CONFIG['outlier_threshold'],
            "variation_pct": round(variation * 100, 2)
        }

    def get_full_analysis(self, sku, country_id):
        salaries = self._get_latest_salaries(country_id)
        df_prices = self._get_price_history(country_id, sku)

        if not salaries or df_prices.empty:
            return {"status": "error", "sku": sku, "message": "Dados insuficientes"}

        price_stats = self._process_price_metrics(df_prices)
        
        # Índice de Paridade: Quantas horas de trabalho (Média vs Mínima) para comprar o item
        avg_h = salaries.get('avg_hour', 0)
        min_h = salaries.get('min_hour', 0)

        return {
            "sku": sku,
            "product_name": PRODUCT_LIST.get(sku, "Produto Desconhecido"),
            "price_metrics": price_stats,
            "hours_needed_avg": round(price_stats['current'] / avg_h, 2) if avg_h > 0 else 0,
            "hours_needed_min": round(price_stats['current'] / min_h, 2) if min_h > 0 else 0
        }