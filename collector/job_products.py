import os
import logging
import requests
import re
from db_connector import get_connection

# Configuração de logs
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configurações Canopy
CANOPY_API_KEY = os.getenv("CANOPY_API_KEY")
CANOPY_URL = "https://graphql.canopyapi.co/"

# Mapeamento de Países (ID do seu banco vs Domínio Amazon)
REGIONS = [
    {"id_country": 1, "domain": "AMAZON_COM_BR", "currency": "BRL"},
    {"id_country": 2, "domain": "AMAZON_COM",    "currency": "USD"},
    {"id_country": 3, "domain": "AMAZON_ES",     "currency": "EUR"}
]

def clean_price(display_price):
    """Transforma '$199.00' em 199.00"""
    if not display_price: return None
    clean_value = re.sub(r'[^\d,.]', '', display_price)
    try:
        if ',' in clean_value and '.' in clean_value:
            clean_value = clean_value.replace('.', '').replace(',', '.')
        elif ',' in clean_value:
            clean_value = clean_value.replace(',', '.')
        return float(clean_value)
    except:
        return None

def fetch_amazon_data(asin, domain):
    """Consulta o Canopy com o formato exato do Playground"""
    headers = {"API-KEY": CANOPY_API_KEY}
    query = """
    query GetProduct($asin: String!, $domain: AmazonDomain) {
      amazonProduct(input: { asinLookup: { asin: $asin, domain: $domain } }) {
        price {
          display
          value
          currency
        }
      }
    }
    """
    variables = {"asin": asin, "domain": domain}
    
    try:
        response = requests.post(CANOPY_URL, json={'query': query, 'variables': variables}, headers=headers)
        data = response.json()
        product = data.get('data', {}).get('amazonProduct')
        
        if product and product.get('price'):
            p = product['price']
            # Se 'value' for null (como no seu teste), usamos o 'display'
            val = p.get('value') if p.get('value') else clean_price(p.get('display'))
            cur = p.get('currency')
            return val, cur
        return None, None
    except Exception as e:
        logger.error(f"Erro na API ({asin}): {e}")
        return None, None

def run_product_collector():
    logger.info("Iniciando coleta de produtos...")
    conn = get_connection()
    cur = conn.cursor()

    try:

        #  Buscar produtos cadastrados
        cur.execute("SELECT sku, product_name FROM products")
        products = cur.fetchall()

        for sku, name in products:
            for reg in REGIONS:
                logger.info(f"Coletando {name} em {reg['domain']}...")
                price, currency = fetch_amazon_data(sku, reg['domain'])

                if price:
                    # Se a API não retornou a moeda, usamos a padrão da região
                    final_currency = currency if currency else reg['currency']
                    
                    cur.execute("""
                        INSERT INTO price_history (sku, id_source, id_country, price, currency)
                        VALUES (%s, %s, %s, %s, %s)
                        ON CONFLICT DO NOTHING
                    """, (sku, 2, reg['id_country'], price, final_currency))
                    
        conn.commit()
        logger.info("Coleta finalizada com sucesso!")
    except Exception as e:
        conn.rollback()
        logger.error(f"Erro no job: {e}")
    finally:
        cur.close()
        conn.close()