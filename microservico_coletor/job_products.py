import os
import logging
import requests
import re
from db_connector import get_connection

logger = logging.getLogger(__name__)

# Configurações via Variáveis de Ambiente
CANOPY_API_KEY = os.getenv("CANOPY_API_KEY")
CANOPY_URL = "https://graphql.canopyapi.co/"

# Mapeamento de Regiões (Domínio para o Canopy e ID para o seu Banco)
REGIONS_TO_COLLECT = [
    {"id_country": 1, "domain": "AMAZON_COM_BR", "default_currency": "BRL"}, 
    {"id_country": 2, "domain": "AMAZON_COM",    "default_currency": "USD"},    
    {"id_country": 3, "domain": "AMAZON_ES",     "default_currency": "EUR"}      
]

def clean_price_string(display_price):
    """
    Transforma strings como '$199.00' ou 'R$ 1.200,50' em float (199.00 ou 1200.50)
    """
    if not display_price:
        return None
    
    # Remove tudo que não for número, vírgula ou ponto
    clean_value = re.sub(r'[^\d,.]', '', display_price)
    
    try:
        # Se tiver os dois (padrão brasileiro 1.200,50), remove o ponto e troca vírgula por ponto
        if ',' in clean_value and '.' in clean_value:
            clean_value = clean_value.replace('.', '').replace(',', '.')
        # Se tiver apenas vírgula (padrão europeu/BR simples 150,00)
        elif ',' in clean_value:
            clean_value = clean_value.replace(',', '.')
            
        return float(clean_value)
    except ValueError:
        return None

def fetch_canopy_price(asin, domain):
    """Faz a chamada GraphQL e trata a resposta vinda do Playground"""
    headers = {"API-KEY": CANOPY_API_KEY}
    
    query = """
    query GetProductData($asin: String!, $domain: AmazonDomain) {
      amazonProduct(input: { asinLookup: { asin: $asin, domain: $domain } }) {
        title
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
        response = requests.post(
            CANOPY_URL, 
            json={'query': query, 'variables': variables}, 
            headers=headers,
            timeout=30
        )
        res_json = response.json()
        
        product = res_json.get('data', {}).get('amazonProduct')
        if not product or not product.get('price'):
            return None

        price_data = product['price']
        
        # Tenta pegar o valor numérico direto; se não vier, limpa o campo 'display'
        value = price_data.get('value')
        if value is None:
            value = clean_price_string(price_data.get('display'))
            
        # Tenta pegar a moeda; se não vier, usa a moeda padrão da região
        currency = price_data.get('currency')
        
        return {
            "value": value,
            "currency": currency if currency else "CHECK_DOMAIN" 
        }

    except Exception as e:
        logger.error(f"Erro ao buscar na API Canopy ({asin} - {domain}): {e}")
        return None

def run_product_collector():
    """Lê do banco, busca na API e salva o histórico de preços"""
    logger.info("Iniciando coleta de preços de produtos...")
    conn = get_connection()
    
    try:
        cur = conn.cursor()
        
        # 1. Busca mapeamentos da Amazon (id_source = 2)
        cur.execute("""
            SELECT p.id_product, m.external_id, p.name 
            FROM products p
            JOIN product_mappings m ON p.id_product = m.id_product
            WHERE m.id_source = 2
        """)
        products = cur.fetchall()

        for p_id, p_asin, p_name in products:
            for region in REGIONS_TO_COLLECT:
                logger.info(f"Buscando {p_name} em {region['domain']}...")
                
                result = fetch_canopy_price(p_asin, region['domain'])
                
                if result and result['value']:
                    # Define a moeda: se a API não mandou, usa a da região definida no topo do código
                    final_currency = result['currency']
                    if final_currency == "CHECK_DOMAIN":
                        final_currency = region['default_currency']

                    # 2. Salva na tabela de preços
                    cur.execute("""
                        INSERT INTO product_prices (id_product, id_country, id_source, price_value, currency)
                        VALUES (%s, %s, %s, %s, %s)
                    """, (p_id, region['id_country'], 2, result['value'], final_currency))
                    
                    logger.info(f"Salvo: {result['value']} {final_currency}")
                
        conn.commit()
    except Exception as e:
        conn.rollback()
        logger.error(f"Falha no processo de coleta: {e}", exc_info=True)
    finally:
        cur.close()
        conn.close()