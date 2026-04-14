import json
import logging
import os
import time
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo

import db_connector
from job_labor import run_salary_collector
from job_products import run_product_collector

os.makedirs("logs", exist_ok=True)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    handlers=[
        logging.FileHandler("logs/coletor.log"),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

# =========================
# CONFIGURAÇÕES DO SCHEDULER
# =========================
TIMEZONE_NAME = os.getenv("COLLECTOR_TIMEZONE", "America/Sao_Paulo")
CHECK_INTERVAL_SECONDS = int(os.getenv("CHECK_INTERVAL_SECONDS", "300"))

# Produtos: semanal
PRODUCTS_WEEKDAY = int(os.getenv("PRODUCTS_WEEKDAY", "0"))  # 0=segunda, 6=domingo
PRODUCTS_HOUR = int(os.getenv("PRODUCTS_HOUR", "3"))
PRODUCTS_MINUTE = int(os.getenv("PRODUCTS_MINUTE", "0"))

# Labor: mensal
LABOR_DAY = int(os.getenv("LABOR_DAY", "1"))
LABOR_HOUR = int(os.getenv("LABOR_HOUR", "4"))
LABOR_MINUTE = int(os.getenv("LABOR_MINUTE", "0"))

STATE_DIR = Path(os.getenv("STATE_DIR", "/app/state"))
STATE_FILE = STATE_DIR / "collector_state.json"

INITIAL_SYNC_ON_START = os.getenv("INITIAL_SYNC_ON_START", "true").lower() == "true"


def get_now():
    return datetime.now(ZoneInfo(TIMEZONE_NAME))


def ensure_state_dir():
    STATE_DIR.mkdir(parents=True, exist_ok=True)


def load_state():
    ensure_state_dir()

    if not STATE_FILE.exists():
        return {
            "last_products_run": None,
            "last_labor_run": None
        }

    try:
        with STATE_FILE.open("r", encoding="utf-8") as f:
            return json.load(f)
    except Exception as e:
        logger.warning(f"Falha ao ler estado do scheduler. Novo estado será criado. Erro: {e}")
        return {
            "last_products_run": None,
            "last_labor_run": None
        }


def save_state(state):
    ensure_state_dir()
    with STATE_FILE.open("w", encoding="utf-8") as f:
        json.dump(state, f, ensure_ascii=False, indent=2)


def run_labor_task():
    logger.info("--- INICIANDO COLETA DE INDICADORES SALARIAIS ---")

    db_connector.truncate_table("staging_labor_indicators")
    indicators = db_connector.get_labor_indicators_by_source(1)

    for ind in indicators:
        try:
            logger.info(f"Coletando indicador salarial: {ind}")
            run_salary_collector(ind, id_source=1)
        except Exception as e:
            logger.error(f"Erro no indicador {ind}: {e}")

    logger.info("--- COLETA DE INDICADORES SALARIAIS FINALIZADA ---")


def run_products_task():
    logger.info("--- INICIANDO COLETA DE PREÇOS (CANOPY/AMAZON) ---")

    try:
        run_product_collector()
    except Exception as e:
        logger.error(f"Erro na coleta de produtos/preços: {e}")

    logger.info("--- COLETA DE PREÇOS FINALIZADA ---")


def run_sync_task():
    logger.info("--- INICIANDO EXECUÇÃO COMPLETA DE COLETA ---")
    run_labor_task()
    run_products_task()
    logger.info("--- EXECUÇÃO COMPLETA FINALIZADA ---")


def initialize_system():
    logger.info("Iniciando Microserviço Coletor")
    try:
        conn = db_connector.get_connection()
        conn.close()
        logger.info("Conexão com Banco de Dados: OK")
    except Exception as e:
        logger.error(f"Falha na conexão crítica: {e}")
        raise SystemExit(1)


def is_same_iso_week(dt_a: datetime, dt_b: datetime) -> bool:
    year_a, week_a, _ = dt_a.isocalendar()
    year_b, week_b, _ = dt_b.isocalendar()
    return year_a == year_b and week_a == week_b


def should_run_products(now: datetime, state: dict) -> bool:
    if now.weekday() != PRODUCTS_WEEKDAY:
        return False

    target_reached = (now.hour > PRODUCTS_HOUR) or (
        now.hour == PRODUCTS_HOUR and now.minute >= PRODUCTS_MINUTE
    )
    if not target_reached:
        return False

    last_run_str = state.get("last_products_run")
    if not last_run_str:
        return True

    last_run = datetime.fromisoformat(last_run_str).astimezone(ZoneInfo(TIMEZONE_NAME))
    if is_same_iso_week(last_run, now):
        return False

    return True


def should_run_labor(now: datetime, state: dict) -> bool:
    if now.day != LABOR_DAY:
        return False

    target_reached = (now.hour > LABOR_HOUR) or (
        now.hour == LABOR_HOUR and now.minute >= LABOR_MINUTE
    )
    if not target_reached:
        return False

    last_run_str = state.get("last_labor_run")
    if not last_run_str:
        return True

    last_run = datetime.fromisoformat(last_run_str).astimezone(ZoneInfo(TIMEZONE_NAME))
    if last_run.year == now.year and last_run.month == now.month:
        return False

    return True


def bootstrap_initial_collection_if_needed():
    state = load_state()

    if not INITIAL_SYNC_ON_START:
        logger.info("INITIAL_SYNC_ON_START desativado. Pulando coleta inicial.")
        return

    first_products_run = not state.get("last_products_run")
    first_labor_run = not state.get("last_labor_run")

    if first_products_run and first_labor_run:
        logger.info("--- PRIMEIRA EXECUÇÃO DETECTADA: iniciando coleta inicial completa ---")
        run_sync_task()
        now = get_now()
        state["last_products_run"] = now.isoformat()
        state["last_labor_run"] = now.isoformat()
        save_state(state)
        logger.info("--- COLETA INICIAL COMPLETA FINALIZADA ---")
    else:
        logger.info("Estado anterior encontrado. Scheduler seguirá normalmente sem coleta inicial.")


def run_scheduler():
    logger.info("--- SCHEDULER ATIVADO ---")
    logger.info(
        f"Timezone={TIMEZONE_NAME} | "
        f"Products: weekday={PRODUCTS_WEEKDAY} {PRODUCTS_HOUR:02d}:{PRODUCTS_MINUTE:02d} | "
        f"Labor: day={LABOR_DAY} {LABOR_HOUR:02d}:{LABOR_MINUTE:02d} | "
        f"check_interval={CHECK_INTERVAL_SECONDS}s"
    )

    bootstrap_initial_collection_if_needed()

    while True:
        state = load_state()
        now = get_now()

        try:
            if should_run_labor(now, state):
                logger.info("Janela mensal de labor detectada. Executando coleta salarial.")
                run_labor_task()
                state["last_labor_run"] = now.isoformat()
                save_state(state)

            if should_run_products(now, state):
                logger.info("Janela semanal de products detectada. Executando coleta de preços.")
                run_products_task()
                state["last_products_run"] = now.isoformat()
                save_state(state)

        except Exception as e:
            logger.exception(f"Erro durante execução agendada: {e}")

        time.sleep(CHECK_INTERVAL_SECONDS)


if __name__ == "__main__":
    initialize_system()

    mode = os.getenv("COLLECT_MODE", "scheduler").lower()

    if mode == "labor":
        run_labor_task()
    elif mode == "products":
        run_products_task()
    elif mode == "sync":
        run_sync_task()
    else:
        run_scheduler()