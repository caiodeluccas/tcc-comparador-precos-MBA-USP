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

def clean_price(display_price):
    """Transforma '$199.00' em 199.00"""
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

    # Query usando o domínio como ENUM (sem aspas)
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
    logger.info("Iniciando coleta de produtos Versão 2 (Mapeamento Global)...")
    conn = get_connection()
    if not conn:
        logger.error("Falha ao conectar no banco de dados.")
        return

    cur = conn.cursor()

    # Dicionário para converter ID do banco no Domínio da API
    # 1: Brasil (BR), 2: EUA (US), 3: Espanha (ES)
    id_to_domain = {1: "BR", 2: "US", 3: "ES"}

    try:
        # A MUDANÇA ESTÁ AQUI: Buscamos o ASIN específico de cada país na nova tabela
        query = """
            SELECT 
                p.sku, 
                pa.search_code, 
                p.product_name, 
                pa.id_country 
            FROM products p
            JOIN product_asins pa ON p.sku = pa.sku
        """
        cur.execute(query)
        tasks = cur.fetchall()

        if not tasks:
            logger.warning("Nenhum mapeamento de produto encontrado na tabela product_asins.")

        for sku, asin, name, id_country in tasks:
            domain = id_to_domain.get(id_country)
            
            if not domain:
                logger.warning(f"ID de país {id_country} não possui mapeamento de domínio.")
                continue

            logger.info(f"Coletando {name} | País: {domain} | ASIN: {asin}")
            
            price, currency = fetch_amazon_data(asin, domain)

            if price:
                # O preço e a moeda vêm da API, se falhar usamos um padrão
                final_currency = currency if currency else "USD"
                
                cur.execute("""
                    INSERT INTO price_history (sku, id_source, id_country, price, currency)
                    VALUES (%s, %s, %s, %s, %s)
                    ON CONFLICT DO NOTHING
                """, (sku, 2, id_country, price, final_currency))
                
                logger.info(f"SUCESSO: {sku} em {domain} -> {final_currency} {price}")
            else:
                logger.warning(f"FALHA: {name} não encontrado em {domain} com ASIN {asin}")
                
        conn.commit()
        logger.info("Coleta finalizada com sucesso!")
    except Exception as e:
        conn.rollback()
        logger.error(f"Erro no coletor: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    run_product_collector()