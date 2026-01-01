import logging
import requests
import pandas as pd
from db_connector import insert_data, get_connection, truncate_table

logger = logging.getLogger(__name__)

def run_salary_collector(indicator_id, id_source=1):
    """
    indicator_id: O código da ILO (ex: 'EAR_XEES_SEX_ECO_NB_M')
    id_source: ID da fonte no seu banco (ex: 1 para ILO)
    """
    logger.info(f"Starting collection for indicator: {indicator_id}...")
    
    # Monta a URL dinamicamente
    url = f'https://rplumber.ilo.org/data/indicator/?id={indicator_id}&format=.json'
    
    try:
        # 1. API Request
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        res = response.json()
        
        df = pd.DataFrame(res)
        
        # Filtros comuns da OIT (Total Sexo e Moeda Local)
        df_clean = df[
            (df['sex'] == 'SEX_T') &
            (df['classif1'] == 'CUR_TYPE_LCU')
        ].copy()
        
        # Ordena e remove duplicatas para pegar o ano mais recente de cada país
        df_clean = df_clean.sort_values(by='time', ascending=False)
        df_latest = df_clean.drop_duplicates(subset=['ref_area'])

        payload = []
        for _, row in df_latest.iterrows():
            payload.append((
                row['ref_area'], 
                row['indicator'], 
                row['obs_value'], 
                row['time'], 
                'LCU'
            ))

        # 2. Database (Staging)
        # Importante: truncamos a staging a cada chamada para não misturar indicadores
        truncate_table("staging_salary")

        columns = ['iso_3_code', 'indicator_code', 'salary_value', 'reference_year', 'currency']
        insert_data('staging_salary', columns, payload)
        
        # Chama a migração passando o id_source
        migrate_salary_staging_to_final(id_source)
        
    except Exception as e:
        logger.error(f"Error collecting {indicator_id}: {e}", exc_info=True)

def migrate_salary_staging_to_final(id_source):
    conn = get_connection()
    try:
        cur = conn.cursor()
        # O SQL agora usa %s para o id_source que passamos na função
        sql_join = """
            INSERT INTO salary_history (id_country, id_indicator, id_source, salary_value, currency, reference_year)
            SELECT 
                c.id_country, 
                i.id_indicator, 
                %s, 
                stg.salary_value, 
                c.base_currency, 
                stg.reference_year
            FROM staging_salary stg
            JOIN countries c ON stg.iso_3_code = c.iso_3_code
            JOIN salary_indicators i ON stg.indicator_code = i.original_code
            ON CONFLICT (id_country, id_indicator, reference_year) DO NOTHING;
        """
        cur.execute(sql_join, (id_source,))
        conn.commit()
        logger.info(f"Migration successful for source {id_source}!")
    except Exception as e:
        conn.rollback()
        logger.error(f"Migration failed: {e}")
    finally:
        conn.close()



