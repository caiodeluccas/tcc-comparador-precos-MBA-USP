import pandas as pd
import numpy as np
from db_connector import get_connection
from processor.conf import SALARY_INDICATORS, ANALYSIS_CONFIG, PRODUCT_LIST, TARGET_COUNTRIES

class DataEngine:
    """Classe base que gerencia a infraestrutura e conexão com o banco"""
    def __init__(self):
        self.conn = get_connection()

    def __del__(self):
        """Garante o fechamento da conexão ao destruir o objeto"""
        if hasattr(self, 'conn') and self.conn:
            self.conn.close()

class EconomicProcessor(DataEngine):
    """Motor de cálculo de paridade e limpeza de dados econômicos"""
    
    def __init__(self):
        super().__init__()

    # --- MÉTODOS PRIVADOS DE BUSCA ---

    def _get_latest_salaries(self, country_id):
        """Busca o último registro de salário para cada indicador (Snapshot)"""
        query = """
            SELECT DISTINCT ON (id_indicator) id_indicator, salary_value
            FROM salary_history
            WHERE id_country = %s
            ORDER BY id_indicator, collection_date DESC
        """
        df = pd.read_sql(query, self.conn, params=(country_id,))
        if df.empty:
            return None
        
        # Mapeia IDs numéricos para nomes amigáveis (Ex: 1 -> 'avg_hour')
        df['label'] = df['id_indicator'].map(SALARY_INDICATORS)
        return df.set_index('label')['salary_value'].to_dict()

    def _get_price_history(self, country_id, sku):
        """Busca os últimos 4 registros de preço para análise de volatilidade"""
        query = """
            SELECT price_value, collection_date 
            FROM price_history
            WHERE id_country = %s AND sku = %s
            ORDER BY collection_date DESC
            LIMIT 4
        """
        return pd.read_sql(query, self.conn, params=(country_id, sku))

    # --- MÉTODOS DE PROCESSAMENTO ---

    def _process_price_metrics(self, df_prices):
        """Calcula estatísticas e identifica se o preço atual é um Outlier"""
        if df_prices.empty:
            return None

        prices = df_prices['price_value'].astype(float)
        current_price = prices.iloc[0]
        avg_price = prices.mean()

        # Validação de Outlier baseada no threshold do conf.py (Ex: 0.60)
        variation = abs((current_price - avg_price) / avg_price) if avg_price > 0 else 0
        is_outlier = variation > ANALYSIS_CONFIG['outlier_threshold']

        return {
            "current": current_price,
            "avg_4w": round(float(avg_price), 2),
            "min_4w": float(prices.min()),
            "max_4w": float(prices.max()),
            "is_outlier": is_outlier,
            "variation_pct": round(variation * 100, 2)
        }

    # --- INTERFACE PÚBLICA (MÉTODOS MESTRE) ---

    def get_full_analysis(self, sku, country_id):
        """Realiza a análise completa de UM produto em UM país"""
        
        salaries = self._get_latest_salaries(country_id)
        df_prices = self._get_price_history(country_id, sku)

        if not salaries or df_prices.empty:
            return {"status": "error", "sku": sku, "message": "Dados insuficientes"}

        price_stats = self._process_price_metrics(df_prices)
        
        # Cálculo do Índice de Paridade: Preço Médio (4 semanas) / Salário Médio Hora
        avg_hour_salary = float(salaries.get('avg_hour', 0))
        hours_needed = round(price_stats['avg_4w'] / avg_hour_salary, 2) if avg_hour_salary > 0 else 0

        return {
            "sku": sku,
            "product_name": PRODUCT_LIST.get(sku, "Produto Desconhecido"),
            "price_metrics": price_stats,
            "salaries": salaries,
            "parity_index": hours_needed
        }

    def get_global_report(self):
        """Gera um relatório comparativo de todos os produtos e países definidos no conf.py"""
        
        report = []
        for country_id in TARGET_COUNTRIES:
            country_data = {
                "country_id": country_id,
                "timestamp": pd.Timestamp.now().strftime('%Y-%m-%d %H:%M'),
                "analyses": []
            }
            
            for sku in PRODUCT_LIST.keys():
                analysis = self.get_full_analysis(sku, country_id)
                if analysis.get("status") != "error":
                    country_data["analyses"].append(analysis)
            
            report.append(country_data)
            
        return report