import pandas as pd
import logging
from collector.db_connector import get_connection

logger = logging.getLogger(__name__)

WEEKS_PER_MONTH = 4.0  # mantenha fixo e documente na metodologia


class DataEngine:
    def __init__(self):
        try:
            self.conn = get_connection()
            logger.info("Conexão com o banco de dados estabelecida pelo DataEngine.")
        except Exception as e:
            logger.error(f"Erro ao conectar ao banco no DataEngine: {e}")
            raise

    def __del__(self):
        if hasattr(self, "conn") and self.conn:
            self.conn.close()
            logger.info("Conexão com o banco encerrada pelo DataEngine.")


class EconomicProcessor(DataEngine):
    def __init__(self):
        super().__init__()
        logger.info("EconomicProcessor inicializado e pronto para processamento.")

    def _get_latest_salaries(self, country_id: int):
        """
        Busca os últimos indicadores salariais do país e devolve:
        - salário médio mensal
        - salário mínimo mensal
        - salário médio por hora
        - salário mínimo por hora
        """
        logger.info(f"Processando indicadores para o país ID: {country_id}")

        query_salary = """
            SELECT DISTINCT ON (id_indicator)
                   id_indicator,
                   indicator_value
            FROM labor_indicators_history
            WHERE id_country = %s
            ORDER BY id_indicator, reference_year DESC
        """

        try:
            df_sal = pd.read_sql(query_salary, self.conn, params=(country_id,))
            if df_sal.empty:
                return None

            vals = dict(zip(df_sal["id_indicator"], df_sal["indicator_value"]))

            # Ajuste conforme seus IDs reais
            avg_month = float(vals.get(1, 0) or 0)      # ID 1: Média salarial mensal
            min_month = float(vals.get(3, 0) or 0)      # ID 3: Salário mínimo mensal
            weekly_hours = float(vals.get(5, 40) or 40) # ID 5: Horas semanais

            monthly_hours = weekly_hours * WEEKS_PER_MONTH if weekly_hours > 0 else 0

            avg_hour = avg_month / monthly_hours if monthly_hours > 0 else 0
            min_hour = min_month / monthly_hours if monthly_hours > 0 else 0

            return {
                "avg_salary_month": avg_month,
                "min_salary_month": min_month,
                "weekly_hours": weekly_hours,
                "monthly_hours": monthly_hours,
                "avg_hour": avg_hour,
                "min_hour": min_hour,
            }

        except Exception as e:
            logger.error(f"Erro ao buscar salários: {e}")
            return None

    def get_full_analysis(self, sku=None, iso3=None):
        """
        Cruza o preço mais recente por produto/país com salários
        e devolve todas as métricas prontas para o frontend.
        """
        query = """
            SELECT DISTINCT ON (p.sku, p.id_country)
                   p.sku,
                   p.price,
                   p.id_country,
                   c.iso_3_code,
                   p.collection_timestamp
            FROM price_history p
            JOIN countries c ON p.id_country = c.id_country
            WHERE 1=1
        """
        params = []

        if sku:
            query += " AND p.sku = %s"
            params.append(sku)

        if iso3:
            query += " AND c.iso_3_code = %s"
            params.append(iso3.upper())

        query += """
            ORDER BY p.sku, p.id_country, p.collection_timestamp DESC
        """

        df_prices = pd.read_sql(query, self.conn, params=params)

        if df_prices.empty:
            return None

        results = []

        for _, row in df_prices.iterrows():
            salaries = self._get_latest_salaries(int(row["id_country"]))
            if not salaries:
                continue

            price = float(row["price"])

            avg_salary_month = salaries["avg_salary_month"]
            min_salary_month = salaries["min_salary_month"]
            avg_hour = salaries["avg_hour"]
            min_hour = salaries["min_hour"]

            price_pct_avg_salary = round((price / avg_salary_month) * 100, 2) if avg_salary_month > 0 else None
            price_pct_min_salary = round((price / min_salary_month) * 100, 2) if min_salary_month > 0 else None

            hours_needed_avg_salary = round(price / avg_hour, 2) if avg_hour > 0 else None
            hours_needed_min_salary = round(price / min_hour, 2) if min_hour > 0 else None

            results.append({
                "sku": row["sku"],
                "iso3": row["iso_3_code"],
                "price": price,

                "avg_salary_month": round(avg_salary_month, 2),
                "min_salary_month": round(min_salary_month, 2),

                "price_pct_avg_salary": price_pct_avg_salary,
                "price_pct_min_salary": price_pct_min_salary,

                "hours_needed_avg_salary": hours_needed_avg_salary,
                "hours_needed_min_salary": hours_needed_min_salary,

            })

        if not results:
            return None

        return pd.DataFrame(results)