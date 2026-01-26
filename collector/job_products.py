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
    {"id_country": 1, "domain": "br", "currency": "BRL"},
    {"id_country": 2, "domain": "us", "currency": "USD"},
    {"id_country": 3, "domain": "es", "currency": "EUR"}
]

def clean_price(display_price):
    """Transforma '$199.00' em 199.00"""
    if not display_price: return None
    # Remove tudo que não é dígito, vírgula ou ponto
    clean_value = re.sub(r'[^\d,.]', '', display_price)
    try:
        # Lógica para tratar separadores de milhar e decimal
        if ',' in clean_value and '.' in clean_value:
            # Caso como 1.200,50 -> 1200.50
            if clean_value.find('.') < clean_value.find(','):
                clean_value = clean_value.replace('.', '').replace(',', '.')
            # Caso como 1,200.50 -> 1200.50
            else:
                clean_value = clean_value.replace(',', '')
        elif ',' in clean_value:
            clean_value = clean_value.replace(',', '.')
        
        return float(clean_value)
    except Exception as e:
        logger.error(f"Erro ao limpar preço '{display_price}': {e}")
        return None

def fetch_amazon_data(asin, domain):
    if not CANOPY_API_KEY:
        logger.error("CANOPY_API_KEY não encontrada!")
        return None, None

    headers = {
        "Content-Type": "application/json",
        "API-KEY": CANOPY_API_KEY.strip()
    }

    # Query simplificada e com o domínio injetado sem aspas (como um ENUM)
    query = """
    query {
      amazonProduct(input: { asinLookup: { asin: "%s", domain: %s } }) {
        price {
          display
          value
          currency
        }
      }
    }
    """ % (asin, domain)

    try:
        response = requests.post(CANOPY_URL, json={'query': query}, headers=headers, timeout=20)
        data = response.json()
        
        # Se houver erro na resposta, o log vai nos mostrar
        if "errors" in data:
            logger.error(f"Erro na Canopy para {domain}: {data['errors'][0]['message']}")
            return None, None

        product = data.get('data', {}).get('amazonProduct')
        if product and product.get('price'):
            p = product['price']
            val = p.get('value') if p.get('value') else clean_price(p.get('display'))
            cur = p.get('currency')
            return val, cur
        
        return None, None
    except Exception as e:
        logger.error(f"Erro na chamada: {e}")
        return None, None
    
def run_product_collector():
    logger.info("Iniciando coleta de produtos via Canopy (Amazon)...")
    conn = get_connection()
    if not conn:
        logger.error("Falha ao conectar no banco de dados.")
        return

    cur = conn.cursor()

    try:
        # BUSCA: sku (id interno) e search_code (ASIN para a API)
        cur.execute("SELECT sku, search_code, product_name FROM products")
        products = cur.fetchall()

        for sku, search_code, name in products:
            for reg in REGIONS:
                # Se não houver search_code, pula
                if not search_code:
                    logger.warning(f"Produto {name} não possui search_code (ASIN) cadastrado.")
                    continue

                logger.info(f"Coletando {name} ({search_code}) em {reg['domain']}...")
                
                # Chamada da API usando o ASIN (search_code)
                price, currency = fetch_amazon_data(search_code, reg['domain'])

                if price:
                    final_currency = currency if currency else reg['currency']
                    
                    # Inserção usando o SKU para manter a relação com a tabela 'products'
                    cur.execute("""
                        INSERT INTO price_history (sku, id_source, id_country, price, currency)
                        VALUES (%s, %s, %s, %s, %s)
                        ON CONFLICT (sku, id_country, id_source, collection_timestamp) DO NOTHING
                    """, (sku, 2, reg['id_country'], price, final_currency))
                    
                    logger.info(f"Sucesso: {name} em {reg['domain']} -> {final_currency} {price}")
                
        conn.commit()
        logger.info("Coleta de preços finalizada!")
    except Exception as e:
        conn.rollback()
        logger.error(f"Erro durante a execução do job de preços: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    run_product_collector()