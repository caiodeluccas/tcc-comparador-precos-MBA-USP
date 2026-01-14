import os
import logging
import psycopg2
from urllib.parse import urlparse, unquote # Importação corrigida

logger = logging.getLogger(__name__)

# A string de conexão é lida APENAS UMA VEZ na inicialização do módulo
DATABASE_URL = os.environ.get("DATABASE_URL")

if not DATABASE_URL:
    raise ValueError("DATABASE_URL environment variable not set.")

# Faz o parsing da URL
result = urlparse(DATABASE_URL)

# IMPORTANTE: unquote decodifica caracteres como @, !, * na senha
DB_PARAMS = {
    'database': result.path[1:],
    'user': result.username,
    'password': unquote(result.password) if result.password else None,
    'host': result.hostname,
    'port': result.port
}

def get_connection():
    try:
        conn = psycopg2.connect(**DB_PARAMS)
        return conn
    except psycopg2.Error as e:
        logger.error(f"ERRO CRÍTICO: Falha ao conectar com o PostgreSQL. {e}")
        raise SystemExit("Serviço Coletor encerrado. Verifique a conexão do DB.")

def insert_data(table_name, columns, data_list):
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cols_str = ", ".join(columns)
        placeholders= ", ".join(["%s"] * len(columns))
        sql = f"INSERT INTO {table_name} ({cols_str}) values ({placeholders})"
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
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute(f"TRUNCATE TABLE {table_name} RESTART IDENTITY CASCADE;")
        conn.commit()
        logger.info(f"Table {table_name} truncated successfully.")
    except Exception as e:
        if conn:
            conn.rollback()
        logger.error(f"Failed to truncate table {table_name}: {e}")
        raise
    finally:
        if conn:
            conn.close()