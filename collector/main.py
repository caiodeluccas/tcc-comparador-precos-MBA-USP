import logging
import os
import db_connector as db_connector
from job_salary import run_salary_collector
# AJUSTE 1: Descomentei o import (ajuste o nome para job_prices se for o caso)
from job_products import run_product_collector 

os.makedirs('logs', exist_ok=True)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(name)s: %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    handlers=[
        logging.FileHandler("logs/coletor.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

def run_sync_task():
    """Executa a coleta completa uma única vez para teste"""
    logger.info("--- INICIANDO COLETA DE TESTE ---")
    
    # 1. Coleta de Salários
    indicators = [
        'EAR_4MTH_SEX_CUR_NB_A', 
        'MWG_2MTH_SEX_CUR_NB_A', 
        'QLS_HW_AVE_NB_A'        
    ]
    
    for ind in indicators:
        try:
            logger.info(f"Coletando indicador: {ind}")
            run_salary_collector(ind, id_source=1)
        except Exception as e:
            logger.error(f"Erro no indicador {ind}: {e}")

    # AJUSTE 2: Coleta de preços (Aqui sim chamamos a de PRODUTOS)
    logger.info("--- INICIANDO COLETA DE PREÇOS (AMAZON) ---")
    try:
        # Aqui ela roda sem argumentos, conforme criamos o arquivo
        run_product_collector()
    except Exception as e:
        logger.error(f"Erro na coleta de produtos/preços: {e}")

def initialize_system():
    logger.info("Iniciando Microserviço Coletor")
    try:
        conn = db_connector.get_connection()
        conn.close()
        logger.info("Conexão com Banco de Dados: OK")
    except Exception as e:
        logger.error(f"Falha na conexão: {e}")
        exit(1)

if __name__ == '__main__':
    initialize_system()
    # Chama a função que roda tudo uma vez e encerra
    run_sync_task()