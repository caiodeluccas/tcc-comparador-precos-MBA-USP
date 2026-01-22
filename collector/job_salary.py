import logging
import requests
import pandas as pd
from database.db_connector import insert_data, get_connection, truncate_table

logger = logging.getLogger(__name__)

def run_salary_collector(indicator_id, id_source=1):
    """
    Coleta dados da ILOSTAT. Funciona para:
    - Salários (ex: EAR_4MTH_SEX_CUR_NB_A)
    - Horas Trabalhadas (ex: QLS_HW_AVE_NB_A)
    """
    logger.info(f"Iniciando coleta ILO para o indicador: {indicator_id}...")
    
    # URL da API Plumber da ILO
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
        # Filtro comum: Total por Sexo (SEX_T)
        mask = (df['sex'] == 'SEX_T')
        
        # Se for indicador de Salário (EAR), precisamos filtrar por Moeda Local (LCU)
        # Conforme visto no arquivo de salários mensais
        if 'EAR_' in indicator_id:
            if 'classif1' in df.columns:
                mask = mask & (df['classif1'] == 'CUR_TYPE_LCU')
            currency_label = 'LCU'
        else:
            # Para indicadores de horas (QLS), a unidade é tempo
            currency_label = 'HRS'
        
        df_clean = df[mask].copy()
        
        # 3. Tratamento de Dados (Pegar ano mais recente por país)
        # O campo 'time' representa o ano
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

        # 4. Banco de Dados (Staging)
        # Limpa a staging para garantir que não haja lixo de execuções anteriores
        truncate_table("staging_salary")

        columns = ['iso_3_code', 'indicator_code', 'salary_value', 'reference_year', 'currency']
        insert_data('staging_salary', columns, payload)
        
        # 5. Migração para Tabela Final
        migrate_salary_staging_to_final(id_source)
        
    except Exception as e:
        logger.error(f"Erro na coleta de {indicator_id}: {e}", exc_info=True)

def migrate_salary_staging_to_final(id_source):
    """
    Move dados da staging para a salary_history fazendo o JOIN com países e indicadores.
    """
    conn = get_connection()
    try:
        cur = conn.cursor()
        # SQL robusto que usa o id_source dinâmico
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
            JOIN countries c ON stg.iso_3_code = c.iso_3_code
            JOIN salary_indicators i ON stg.indicator_code = i.indicator_code
            ON CONFLICT (id_country, id_indicator, reference_year) 
            DO UPDATE SET salary_value = EXCLUDED.salary_value;
        """
        cur.execute(sql_join, (id_source,))
        conn.commit()
        logger.info(f"Migração concluída com sucesso para a fonte {id_source}!")
    except Exception as e:
        conn.rollback()
        logger.error(f"Falha na migração: {e}")
    finally:
        conn.close()