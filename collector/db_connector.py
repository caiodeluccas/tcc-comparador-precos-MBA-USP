import os
import logging
import psycopg2
from urllib.parse import urlparse, unquote

logger = logging.getLogger(__name__)

DATABASE_URL = os.environ.get("DATABASE_URL")

if not DATABASE_URL:
    raise ValueError("DATABASE_URL environment variable not set.")

result = urlparse(DATABASE_URL)

DB_PARAMS = {
    'database': result.path[1:],
    'user': result.username,
    'password': unquote(result.password) if result.password else None,
    'host': result.hostname,
    'port': result.port
}

def get_connection():
    """Estabelece conexão com o PostgreSQL"""
    try:
        conn = psycopg2.connect(**DB_PARAMS)
        return conn
    except psycopg2.Error as e:
        logger.error(f"ERRO CRÍTICO: Falha ao conectar com o PostgreSQL. {e}")
        raise SystemExit("Serviço Coletor encerrado. Verifique a conexão do DB.")

def insert_data(table_name, columns, data_list):
    """Insere múltiplos registros de forma eficiente (Batch Insert)"""
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cols_str = ", ".join(columns)
        placeholders = ", ".join(["%s"] * len(columns))
        sql = f"INSERT INTO {table_name} ({cols_str}) VALUES ({placeholders})"
        cursor.executemany(sql, data_list)
        conn.commit()
        return cursor.rowcount
    except psycopg2.Error as e:
        logger.error(f"Erro ao inserir dados na tabela {table_name}: {e}")
        if conn:
            conn.rollback()
        return 0
    finally:
        if conn:
            conn.close()

def truncate_table(table_name):
    """Limpa a tabela antes de novas cargas (útil para Staging)"""
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute(f"TRUNCATE TABLE {table_name} RESTART IDENTITY CASCADE;")
        conn.commit()
        logger.info(f"Tabela {table_name} limpa com sucesso (Truncate).")
    except Exception as e:
        if conn:
            conn.rollback()
        logger.error(f"Falha ao limpar tabela {table_name}: {e}")
        raise
    finally:
        if conn:
            conn.close()

def get_labor_indicators_by_source(id_source):
    """Busca os códigos dos indicadores cadastrados para uma fonte"""
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT indicator_code
            FROM labor_indicators
            WHERE id_source = %s
            ORDER BY id_indicator;
        """, (id_source,))
        rows = cur.fetchall()
        indicators = [row[0] for row in rows]
        logger.info(f"Foram encontrados {len(indicators)} indicadores para a source {id_source}.")
        return indicators
    except Exception as e:
        logger.error(f"Erro ao buscar indicadores da fonte {id_source}: {e}")
        return []
    finally:
        if conn:
            conn.close()