import logging
import os
import db_connector
from apscheduler.schedulers.blocking import BlockingScheduler

os.makedirs('logs', exist_ok = True)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(name)s: %(message)s',
    datefmt = '%Y-%m-%d %H:%M:%S',
    handlers = [
        logging.FileHandler("logs/coletor.log"),
        logging.StremHandler()
    ]
)

logger = logging.getLogger(__name__)


def initialize_system():
    logger.info("Iniciando Microserviço Coletor")
    try:
        coon_test = db_connector.get_connection()
        conn_test.close()
    except Exception as e:
        logging.error(f"Falha na inicialização: {e}")
        raise
if __name__ == '__main__':
    initialize_system()

    scheduler = BlockingScheduler()


    logging.info("Agendador iniciado. Aguardadno próximas tarefas...")
    try:
        scheduler.start()
    except (KeyboardInterrupt, SystemExit):
        logging.warning("Serviço interrompido pelo usuário.")