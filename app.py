import logging
import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import pandas as pd
import numpy as np

# Importação do motor de cálculo
from processor.data_processor import EconomicProcessor

# --- CONFIGURAÇÃO DE LOGS (PADRÃO TCC/MBA) ---
os.makedirs('logs', exist_ok=True)
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(name)s: %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    handlers=[
        logging.FileHandler("logs/api.log"), # Log específico da API
        logging.StreamHandler()              # Mostra no terminal do Docker
    ]
)
logger = logging.getLogger("API_ECONOMICA")

# 1. Inicialização da API
app = FastAPI(
    title="Sistema de Paridade de Preços e Salários",
    description="API para análise de indicadores econômicos e poder de compra.",
    version="1.0.0"
)

# 2. Configuração de CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# 3. Instância do Processador
try:
    engine = EconomicProcessor()
    logger.info("Motor de Processamento (EconomicProcessor) inicializado com sucesso.")
except Exception as e:
    logger.error(f"FALHA CRÍTICA NA CONEXÃO COM O BANCO: {e}")
    engine = None

# --- FUNÇÃO AUXILIAR DE SERIALIZAÇÃO ---
def serializar(dados):
    """Converte tipos científicos NumPy/Pandas para formatos JSON nativos."""
    if isinstance(dados, pd.DataFrame):
        return dados.replace({np.nan: None}).to_dict(orient='records')
    if isinstance(dados, dict):
        return dados
    return dados

# --- ROTAS DA API ---

@app.get("/", tags=["Healthcheck"])
def home():
    logger.info("Acesso ao endpoint de Healthcheck.")
    return {
        "status": "online",
        "projeto": "MBA - Paridade de Preços",
        "database_connected": engine is not None
    }

@app.get("/relatorio-geral", tags=["Relatórios"])
async def obter_relatorio_geral():
    if not engine:
        logger.error("Tentativa de acesso ao relatório com motor offline.")
        raise HTTPException(status_code=500, detail="Motor de processamento offline.")
    try:
        logger.info("Gerando relatório geral de paridade.")
        resultado = engine.get_global_report()
        return serializar(resultado)
    except Exception as e:
        logger.error(f"Erro no relatório geral: {e}")
        raise HTTPException(status_code=500, detail=f"Erro interno: {str(e)}")

@app.get("/analise/pais/{country_id}", tags=["Consultas por Abrangência"])
async def analise_por_pais(country_id: int):
    logger.info(f"Requisição: Análise global para o país ID {country_id}.")
    if not engine:
        raise HTTPException(status_code=500, detail="Motor offline.")
    resultado = engine.get_full_analysis(sku=None, country_id=country_id)
    return serializar(resultado)

@app.get("/analise/produto/{sku}", tags=["Consultas por Abrangência"])
async def analise_por_produto(sku: str):
    logger.info(f"Requisição: Ranking global para o SKU {sku}.")
    if not engine:
        raise HTTPException(status_code=500, detail="Motor offline.")
    resultado = engine.get_full_analysis(sku=sku, country_id=None)
    return serializar(resultado)

@app.get("/analise/detalhada/{country_id}/{sku}", tags=["Consultas Específicas"])
async def obter_analise_detalhada(country_id: int, sku: str):
    logger.info(f"Requisição: Detalhes SKU {sku} no país ID {country_id}.")
    if not engine:
        raise HTTPException(status_code=500, detail="Motor offline.")

    resultado = engine.get_full_analysis(sku, country_id)
    
    if isinstance(resultado, dict) and resultado.get("status") == "error":
        logger.warning(f"Dados não encontrados para SKU {sku} e país {country_id}.")
        raise HTTPException(status_code=404, detail=resultado.get("message"))
        
    return serializar(resultado)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)