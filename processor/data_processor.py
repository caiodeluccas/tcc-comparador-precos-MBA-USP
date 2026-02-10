import pandas as pd
import numpy as np
import logging
from collector.db_connector import get_connection
# Verifique se os nomes das variáveis no seu conf.py batem com esses
from processor.conf import SALARY_INDICATORS, ANALYSIS_CONFIG, PRODUCT_LIST, TARGET_COUNTRIES

# --- CONFIGURAÇÃO DE LOGS ---
# Segue a hierarquia configurada na api.py ou main.py
logger = logging.getLogger(__name__)

class DataEngine:
    def __init__(self):
        try:
            self.conn = get_connection()
            logger.info("Conexão com o banco de dados estabelecida pelo DataEngine.")
        except Exception as e:
            logger.error(f"Erro ao conectar ao banco no DataEngine: {e}")
            raise

    def __del__(self):
        if hasattr(self, 'conn') and self.conn:
            self.conn.close()
            logger.info("Conexão com o banco encerrada pelo DataEngine.")

class EconomicProcessor(DataEngine):
    def __init__(self):
        super().__init__()
        logger.info("EconomicProcessor inicializado e pronto para processamento.")

    def _get_latest_salaries(self, country_id):
        """Busca e normaliza salários para valor por hora."""
        logger.info(f"Processando salários para o país ID: {country_id}")
        
        query_salary = """
            SELECT DISTINCT ON (id_indicator) id_indicator, salary_value
            FROM salary_history
            WHERE id_country = %s
            ORDER BY id_indicator, reference_year DESC
        """
        try:
            df_sal = pd.read_sql(query_salary, self.conn, params=(country_id,))
            if df_sal.empty:
                logger.warning(f"Nenhum dado salarial encontrado para o país {country_id}")
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
            
            # Cálculo de salário-hora (Normalização)
            if 2 in raw_salaries: # Já é valor hora
                processed['avg_hour'] = float(raw_salaries[2])
            elif 1 in raw_salaries: # Valor mensal -> converte para hora
                processed['avg_hour'] = float(raw_salaries[1]) / (avg_weekly_hours * 4.33)
                
            if 4 in raw_salaries: # Salário mínimo hora
                processed['min_hour'] = float(raw_salaries[4])
            elif 3 in raw_salaries: # Salário mínimo mensal
                processed['min_hour'] = float(raw_salaries[3]) / (avg_weekly_hours * 4.33)

            return processed
        except Exception as e:
            logger.error(f"Erro ao processar salários do país {country_id}: {e}")
            return None

    def _get_price_data(self, sku=None, country_id=None):
        """Busca preços históricos filtrados."""
        logger.info(f"Buscando preços: SKU={sku}, Country={country_id}")
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
        """Orquestra a análise cruzando preços e salários."""
        logger.info(f"Iniciando análise completa para SKU: {sku or 'TODOS'} | País: {country_id or 'TODOS'}")
        
        df_prices = self._get_price_data(sku, country_id)
        
        if df_prices.empty:
            logger.warning("Análise abortada: Nenhum preço encontrado.")
            return {"status": "error", "message": "Nenhum preço encontrado."}

        results = []
        combinations = df_prices.groupby(['id_country', 'sku'])
        
        for (c_id, s_id), group in combinations:
            salaries = self._get_latest_salaries(c_id)
            if not salaries: 
                continue
            
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

        if not results:
            logger.error("Falha ao cruzar dados de preços com indicadores salariais.")
            return {"status": "error", "message": "Erro no cruzamento de dados."}
        
        logger.info(f"Análise finalizada com {len(results)} registros processados.")
        
        if sku and country_id and len(results) == 1:
            return results[0]
            
        return pd.DataFrame(results)