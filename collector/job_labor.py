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

    url = (
        "https://rplumber.ilo.org/data/indicator/"
        f"?id={indicator_id}&format=.json&sex=SEX_T&latestyear=TRUE"
    )

    try:
        # 1. Requisição à API
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        res = response.json()

        df = pd.DataFrame(res)

        if df.empty:
            logger.warning(f"Nenhum dado retornado para {indicator_id}")
            return

        # 2. Filtragem
        # Segurança: se por algum motivo a API não respeitar sex=SEX_T, filtramos aqui também.
        mask = pd.Series(True, index=df.index)
        if 'sex' in df.columns:
            mask = mask & (df['sex'] == 'SEX_T')

        # Define label de unidade pra você distinguir na tabela
        if indicator_id.startswith('EAR_'):
            unit_label_label = 'LCU'

            # Só filtra para LCU se:
            # - a coluna existir
            # - e o código CUR_TYPE_LCU realmente aparecer nos dados
            # Assim você não elimina indicadores EAR_* que não usam esse classif.
            if 'classif1' in df.columns and (df['classif1'] == 'CUR_TYPE_LCU').any():
                mask = mask & (df['classif1'] == 'CUR_TYPE_LCU')

        else:
            unit_label_label = 'HRS'

        df_clean = df[mask].copy()

        if df_clean.empty:
            logger.warning(
                f"Nenhum dado após filtragem (sex=SEX_T e LCU quando aplicável) para {indicator_id}"
            )
            return

        # 3. Tratamento de Dados
        # Com latestyear=TRUE normalmente já vem 1 linha por país, mas garantimos.
        if 'time' in df_clean.columns:
            df_clean = df_clean.sort_values(by='time', ascending=False)

        df_latest = df_clean.drop_duplicates(subset=['ref_area'], keep='first')

        payload = []
        for _, row in df_latest.iterrows():
            payload.append((
                row['ref_area'],
                indicator_id,
                row['obs_value'],
                row['time'],
                unit_label_label
            ))

        # 4. Limpeza da Staging
        truncate_table("staging_labor_indicators")

        # 5. Inserção na Staging
        columns = ['iso_3_code', 'indicator_code', 'indicator_value', 'reference_year', 'unit_label']
        insert_data('staging_labor_indicators', columns, payload)
        logger.info(f"Inseridos {len(payload)} registros na staging para {indicator_id}")


        # 6. Migração para Tabela Final
        migrate_salary_staging_to_final(id_source)

    except Exception as e:
        logger.error(f"Erro na coleta de {indicator_id}: {e}")


def migrate_salary_staging_to_final(id_source):
    """
    Move dados da staging para a labor_indicators_history com JOIN robusto.
    """
    conn = get_connection()
    try:
        cur = conn.cursor()

        sql_join = """
            INSERT INTO labor_indicators_history (id_country, id_indicator, id_source, indicator_value, unit_label, reference_year)
            SELECT 
                c.id_country, 
                i.id_indicator, 
                %s, 
                stg.indicator_value, 
                stg.unit_label, 
                stg.reference_year
            FROM staging_labor_indicators stg
            JOIN countries c ON UPPER(TRIM(stg.iso_3_code)) = UPPER(TRIM(c.iso_3_code))
            JOIN labor_indicators i ON UPPER(TRIM(stg.indicator_code)) = UPPER(TRIM(i.indicator_code))
            ON CONFLICT (id_country, id_indicator, reference_year) 
            DO UPDATE SET 
                indicator_value = EXCLUDED.indicator_value,
                id_source = EXCLUDED.id_source,
                unit_label = EXCLUDED.unit_label;
        """

        cur.execute(sql_join, (id_source,))
        rows_inserted = cur.rowcount
        conn.commit()
        logger.info(f"Sucesso: {rows_inserted} linhas inseridas/atualizadas na labor_indicators_history.")

    except Exception as e:
        if conn:
            conn.rollback()
        logger.error(f"Falha na migração: {e}")
    finally:
        if conn:
            conn.close()