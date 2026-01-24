import logging
import requests
import pandas as pd
from db_connector import insert_data, get_connection, truncate_table

logger = logging.getLogger(__name__)

def run_salary_collector(indicator_id, id_source=1):
    """
    Coleta dados da ILOSTAT (Salários e Horas Trabalhadas).
    """
    logger.info(f"Iniciando coleta ILO para o indicador: {indicator_id}...")
    
    # URL da API da ILO
    url = f'https://rplumber.ilo.org/data/indicator/?id={indicator_id}&format=.json'
    
    try:
        # 1. Requisição à API
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        res = response.json()
        
        df = pd.DataFrame(res)
        
        if df.empty:
            logger.warning(f"Nenhum dado retornado para {indicator_id}")
            return

        # 2. Filtragem Inteligente
        # Filtro: Total por Sexo (SEX_T) para evitar duplicar por gênero
        mask = (df['sex'] == 'SEX_T')
        
        # Se for indicador de Salário (EAR), filtramos por Moeda Local (CUR_TYPE_LCU)
        if 'EAR_' in indicator_id:
            if 'classif1' in df.columns:
                mask = mask & (df['classif1'] == 'CUR_TYPE_LCU')
            currency_label = 'LCU'
        else:
            currency_label = 'HRS'
        
        df_clean = df[mask].copy()
        
        # 3. Tratamento de Dados (Pegar apenas o ano mais recente por país)
        df_clean = df_clean.sort_values(by='time', ascending=False)
        df_latest = df_clean.drop_duplicates(subset=['ref_area'])

        payload = []
        for _, row in df_latest.iterrows():
            payload.append((
                row['ref_area'],      # ISO 3 do país
                row['indicator'],     # Código do indicador
                row['obs_value'],     # Valor numérico
                row['time'],          # Ano de referência
                currency_label
            ))

        # 4. Limpeza da Staging (Garante que não há lixo de coletas anteriores)
        truncate_table("staging_salary")

        # 5. Inserção na Staging
        columns = ['iso_3_code', 'indicator_code', 'salary_value', 'reference_year', 'currency']
        insert_data('staging_salary', columns, payload)
        
        # 6. Migração para Tabela Final (Transformação e Carga)
        migrate_salary_staging_to_final(id_source)
        
    except Exception as e:
        logger.error(f"Erro na coleta de {indicator_id}: {e}", exc_info=True)

def migrate_salary_staging_to_final(id_source):
    """
    Move dados da staging para a salary_history com JOIN robusto.
    """
    conn = get_connection()
    try:
        cur = conn.cursor()
        
        # Query com tratamento de strings (TRIM/UPPER) e suporte a conflitos (UPSERT)
        sql_join = """
            INSERT INTO salary_history (id_country, id_indicator, id_source, salary_value, currency, reference_year)
            SELECT 
                c.id_country, 
                i.id_indicator, 
                %s, 
                stg.salary_value, 
                stg.currency, 
                stg.reference_year
            FROM staging_salary stg
            JOIN countries c ON UPPER(TRIM(stg.iso_3_code)) = UPPER(TRIM(c.iso_3_code))
            JOIN salary_indicators i ON UPPER(TRIM(stg.indicator_code)) = UPPER(TRIM(i.indicator_code))
            ON CONFLICT (id_country, id_indicator, reference_year) 
            DO UPDATE SET 
                salary_value = EXCLUDED.salary_value,
                id_source = EXCLUDED.id_source;
        """
        
        cur.execute(sql_join, (id_source,))
        conn.commit()
        logger.info(f"Migração concluída com sucesso para a fonte {id_source}!")
        
    except Exception as e:
        conn.rollback()
        logger.error(f"Falha na migração de staging para final: {e}")
    finally:
        conn.close()