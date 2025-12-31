import logging
import requests
import pandas as pd
from db_connector import insert_data, get_connection, truncate_table

logger = logging.getLogger(__name__)

def run_salary_collector():
    logger.info("Starting salary collection...")
    
    try:
        # 1. API Request
        response = requests.get('https://rplumber.ilo.org/data/indicator/?id=EAR_XEES_SEX_ECO_NB_M&format=.json', timeout=30)
        response.raise_for_status() # This ensures 4xx/5xx errors are caught
        res = response.json()
        logger.info("Data fetched successfully from ILO API.")

        df = pd.DataFrame(res)
        
        df_clean = df[
            (df['sex'] == 'SEX_T') &
            (df['classif1'] == 'CUR_TYPE_LCU')
        ].copy()
        
        logger.info(f"Data cleaned. {len(df_clean)} records ready to be inserted.")

        # Ordena pelo ano (time) do maior para o menor
        df_clean = df_clean.sort_values(by='time', ascending=False)

        # Remove duplicatas de país, mantendo apenas a primeira (que será a mais atual devido ao sort)
        df_latest = df_clean.drop_duplicates(subset=['ref_area'])

        logger.info(f"Filtered for the most recent data. Total countries: {len(df_latest)}")

        payload = []
        for _, row in df_latest.iterrows():
            payload.append((
                row['ref_area'], 
                row['indicator'], 
                row['obs_value'], 
                row['time'],  # Esse ano é o que evita a duplicata no SQL
                'LCU'
            ))

        # 2. Database Insertion
        # Limpando a staging antes de inserir os novos dados
        truncate_table("staging_salary")

        columns = ['iso_3_code', 'indicator_code', 'salary_value', 'reference_year', 'currency']
        insert_data('staging_salary', columns, payload)
        migrate_salary_staging_to_final()
        
    except requests.exceptions.RequestException as e:
        logger.error(f"API Connection error: {e}")
    except Exception as e:
        # exc_info=True adds the full error stack to the log file
        logger.error(f"Unexpected error in salary collector: {e}", exc_info=True)
    finally:
        logger.info("Salary collector process finished.")

def migrate_salary_staging_to_final():
    # 1. Chama a função para obter a conexão
    conn = get_connection()

    try:
        cur = conn.cursor()

        # 2. Executa o SQL que cruza as tabelas
        sql_join = """
            INSERT INTO salary_history (id_country, id_indicator, id_source, salary_value, currency, reference_year)
            SELECT 
                c.id_country, 
                i.id_indicator, -- Usando o ID da tabela de indicadores
                1,              -- ID da fonte ILO
                stg.salary_value, 
                c.base_currency, 
                stg.reference_year
            FROM staging_salary stg
            JOIN countries c ON stg.iso_3_code = c.iso_3_code
            JOIN salary_indicators i ON stg.indicator_code = i.original_code
            ON CONFLICT (id_country, id_indicator, reference_year) DO NOTHING;
        """
        cur.execute(sql_join)

        # 3. Salva as alterações
        conn.commit()
        logger.info("Migration sucessfull!!")

    except Exception as e:
        conn.rollback()
        logger.error(f"Migration failed: {e}")
    finally:
        conn.close()



