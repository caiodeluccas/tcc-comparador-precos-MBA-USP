import logging
import os
import db_connector as db_connector
from job_salary import run_salary_collector
# from collector.job_products import run_product_collector 

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
    
    # Lista de indicadores que você precisa no banco
    indicators = [
        'EAR_4MTH_SEX_CUR_NB_A', # Salário Médio Mensal
        'MWG_2MTH_SEX_CUR_NB_A', # Salário Mínimo Mensal
        'QLS_HW_AVE_NB_A'        # Média de Horas
    ]
    
    for ind in indicators:
        try:
            logger.info(f"Coletando indicador: {ind}")
            run_salary_collector(ind, id_source=1)
        except Exception as e:
            logger.error(f"Erro no indicador {ind}: {e}")

    # Quando o job_products estiver pronto, você ativa aqui:
    # run_product_collector()
    
    logger.info("--- TESTE FINALIZADO ---")

def initialize_system():
    logger.info("Iniciando Microserviço Coletor")
    try:
        conn = db_connector.get_connection()
        conn.close()
        logger.info("Conexão com Banco de Dados: OK")
    except Exception as e:
        logger.error(f"Falha na conexão: {e}")
        exit(1) # Para o script aqui se o banco não estiver acessível

if __name__ == '__main__':
    initialize_system()

    # Executa a tarefa de teste
    run_sync_task()

    # O Scheduler fica comentado por enquanto para não "travar" o terminal
    """
    from apscheduler.schedulers.blocking import BlockingScheduler
    scheduler = BlockingScheduler()
    scheduler.add_job(run_sync_task, 'interval', hours=24)
    logger.info("Agendador em standby...")
    scheduler.start()
    """