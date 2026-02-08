import pandas as pd
import numpy as np
from collector.db_connector import get_connection
# Verifique se os nomes das variáveis no seu conf.py batem com esses
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
        # ... (mantenha sua lógica de _get_latest_salaries igual, ela já funciona bem por país)
        query_salary = """
            SELECT DISTINCT ON (id_indicator) id_indicator, salary_value
            FROM salary_history
            WHERE id_country = %s
            ORDER BY id_indicator, reference_year DESC
        """
        df_sal = pd.read_sql(query_salary, self.conn, params=(country_id,))
        if df_sal.empty:
            return None
        
        query_hours = """
            SELECT value FROM country_stats 
            WHERE id_country = %s AND id_indicator = 5
            ORDER BY year DESC LIMIT 1
        """
        res_hours = pd.read_sql(query_hours, self.conn, params=(country_id,))
        avg_weekly_hours = float(res_hours['value'].iloc[0]) if not res_hours.empty else 40.0
        
        raw_salaries = df_sal.set_index('id_indicator')['salary_value'].to_dict()
        processed = {}
        
        if 2 in raw_salaries:
            processed['avg_hour'] = float(raw_salaries[2])
        elif 1 in raw_salaries:
            processed['avg_hour'] = float(raw_salaries[1]) / (avg_weekly_hours * 4.33)
            
        if 4 in raw_salaries:
            processed['min_hour'] = float(raw_salaries[4])
        elif 3 in raw_salaries:
            processed['min_hour'] = float(raw_salaries[3]) / (avg_weekly_hours * 4.33)

        return processed

    def _get_price_data(self, sku=None, country_id=None):
        """MÉTODO NOVO: Busca preços de forma dinâmica."""
        query = """
            SELECT price, sku, id_country, collection_timestamp as collection_date 
            FROM price_history
            WHERE 1=1
        """
        params = []
        if sku:
            query += " AND sku = %s"
            params.append(sku)
        if country_id:
            query += " AND id_country = %s"
            params.append(country_id)
            
        query += " ORDER BY collection_timestamp DESC"
        return pd.read_sql(query, self.conn, params=params)

    def get_full_analysis(self, sku=None, country_id=None):
        """MÉTODO MESTRE: Orquestra a análise baseada nos filtros fornecidos."""
        
        # 1. Busca os dados brutos de preço
        df_prices = self._get_price_data(sku, country_id)
        
        if df_prices.empty:
            return {"status": "error", "message": "Nenhum preço encontrado para os filtros aplicados."}

        # 2. Se for análise de VÁRIOS produtos ou VÁRIOS países, processamos como lista
        results = []
        
        # Agrupamos por país e sku para calcular os índices de cada combinação
        combinations = df_prices.groupby(['id_country', 'sku'])
        
        for (c_id, s_id), group in combinations:
            # Busca salário do país atual do loop
            salaries = self._get_latest_salaries(c_id)
            if not salaries: continue
            
            # Pega o preço mais recente (primeiro do grupo já ordenado por data)
            current_price = float(group['price'].iloc[0])
            avg_h = salaries.get('avg_hour', 0)
            min_h = salaries.get('min_hour', 0)
            
            analysis = {
                "sku": s_id,
                "product_name": PRODUCT_LIST.get(s_id, s_id),
                "country_id": int(c_id),
                "price": current_price,
                "hours_needed_avg": round(current_price / avg_h, 2) if avg_h > 0 else 0,
                "hours_needed_min": round(current_price / min_h, 2) if min_h > 0 else 0,
                "collection_date": str(group['collection_date'].iloc[0])
            }
            results.append(analysis)

        # 3. Retorno inteligente
        if not results:
            return {"status": "error", "message": "Não foi possível cruzar preços com salários."}
        
        # Se o usuário pediu 1 item específico em 1 país específico, retorna só o dicionário
        if sku and country_id and len(results) == 1:
            return results[0]
            
        # Caso contrário (múltiplos países ou múltiplos produtos), retorna a lista para o ranking
        return pd.DataFrame(results)