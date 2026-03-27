import os
import logging
import requests
import re
from db_connector import get_connection

# Apenas define o logger, a configuração vem do main.py
logger = logging.getLogger(__name__)

CANOPY_API_KEY = os.getenv("CANOPY_API_KEY")
CANOPY_URL = "https://graphql.canopyapi.co/"

def clean_price(display_price):
    if not display_price: return None
    clean_value = re.sub(r'[^\d,.]', '', display_price)
    try:
        if ',' in clean_value and '.' in clean_value:
            if clean_value.find('.') < clean_value.find(','):
                clean_value = clean_value.replace('.', '').replace(',', '.')
            else:
                clean_value = clean_value.replace(',', '')
        elif ',' in clean_value:
            clean_value = clean_value.replace(',', '.')
        return float(clean_value)
    except Exception as e:
        logger.error(f"Erro ao limpar preço: {e}")
        return None

def fetch_amazon_data(asin, domain):
    if not CANOPY_API_KEY:
        logger.error("API KEY AUSENTE!")
        return None, None
    headers = {"Content-Type": "application/json", "API-KEY": CANOPY_API_KEY.strip()}
    query = """query { amazonProduct(input: { asinLookup: { asin: "%s", domain: %s } }) { price { display value currency } } } """ % (asin, domain)
    try:
        response = requests.post(CANOPY_URL, json={'query': query}, headers=headers, timeout=20)
        data = response.json()
        logger.info(f"Canopy response para {asin}/{domain}: {data}")
        product = data.get('data', {}).get('amazonProduct')
        if product and product.get('price'):
            p = product['price']
            val = p.get('value') if p.get('value') else clean_price(p.get('display'))
            return val, p.get('currency')
        return None, None
    except Exception as e:
        logger.error(f"Erro na API Canopy: {e}")
        return None, None
    
def run_product_collector():
    logger.info("Iniciando coleta Canopy via Mapeamento Global...")
    conn = get_connection()
    cur = conn.cursor()

    try:
        cur.execute("""
            SELECT
                p.sku,
                pa.search_code,
                p.product_name,
                pa.id_country,
                c.iso_2_code
            FROM products p
            JOIN product_asins pa ON p.sku = pa.sku
            JOIN countries c ON c.id_country = pa.id_country
        """)
        tasks = cur.fetchall()

        for sku, asin, name, id_country, iso_2_code in tasks:
            domain = iso_2_code.upper()

            price, currency = fetch_amazon_data(asin, domain)

            if price is not None:
                cur.execute("""
                    INSERT INTO price_history (sku, id_source, id_country, price, unit_label)
                    VALUES (%s, %s, %s, %s, %s)
                    ON CONFLICT DO NOTHING
                """, (sku, 2, id_country, price, currency or "USD"))

                logger.info(f"SUCESSO: {sku} em {domain} -> {price}")
            else:
                logger.info(f"SEM PREÇO: {sku} em {domain} -> ASIN {asin}")

        conn.commit()

    finally:
        cur.close()