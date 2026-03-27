import logging
import os
import db_connector
from job_labor import run_salary_collector
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
    logger.info("--- INICIANDO EXECUÇÃO ÚNICA DE COLETA ---")
    
    db_connector.truncate_table("staging_labor_indicators")
    
    indicators = db_connector.get_labor_indicators_by_source(1)
    
    for ind in indicators:
        try:
            logger.info(f"Coletando indicador salarial: {ind}")
            run_salary_collector(ind, id_source=1)
        except Exception as e:
            logger.error(f"Erro no indicador {ind}: {e}")

    logger.info("--- INICIANDO COLETA DE PREÇOS (CANOPY/AMAZON) ---")
    try:
        run_product_collector()
    except Exception as e:
        logger.error(f"Erro na coleta de produtos/preços: {e}")
    
    logger.info("--- TAREFA FINALIZADA COM SUCESSO ---")

def initialize_system():
    logger.info("Iniciando Microserviço Coletor")
    try:
        conn = db_connector.get_connection()
        conn.close()
        logger.info("Conexão com Banco de Dados: OK")
    except Exception as e:
        logger.error(f"Falha na conexão crítica: {e}")
        exit(1)

if __name__ == '__main__':
    initialize_system()
    run_sync_task()