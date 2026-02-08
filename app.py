from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import pandas as pd
import numpy as np

# Importação do seu motor de cálculo
from processor.data_processor import EconomicProcessor

# 1. Inicialização da API
app = FastAPI(
    title="Sistema de Paridade de Preços e Salários",
    description="API para análise de indicadores econômicos e poder de compra (MBA).",
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
except Exception as e:
    print(f"ERRO AO CONECTAR NO BANCO: {e}")
    engine = None

# --- FUNÇÃO AUXILIAR PARA EVITAR ERROS DE JSON (NUMPY/PANDAS) ---
def serializar(dados):
    """Converte DataFrames e tipos NumPy para formatos aceitos pelo JSON."""
    if isinstance(dados, pd.DataFrame):
        # Transforma DataFrame em lista de dicionários e lida com valores nulos (NaN)
        return dados.replace({np.nan: None}).to_dict(orient='records')
    if isinstance(dados, dict):
        return dados
    return dados

# --- ROTAS DA API ---

@app.get("/", tags=["Healthcheck"])
def home():
    """Verifica se a API está online."""
    return {
        "status": "online",
        "projeto": "MBA - Paridade de Preços",
        "database_connected": engine is not None
    }

@app.get("/relatorio-geral", tags=["Relatórios"])
async def obter_relatorio_geral():
    if not engine:
        raise HTTPException(status_code=500, detail="Motor de processamento offline.")
    try:
        resultado = engine.get_global_report()
        return serializar(resultado)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro: {str(e)}")

# NOVA ROTA: Todos os produtos de um país
@app.get("/analise/pais/{country_id}", tags=["Consultas por Abrangência"])
async def analise_por_pais(country_id: int):
    """Retorna todos os produtos e seus índices para um país específico."""
    if not engine:
        raise HTTPException(status_code=500, detail="Motor offline.")
    
    # Passamos sku=None para o seu processador entender que quer todos do país
    resultado = engine.get_full_analysis(sku=None, country_id=country_id)
    return serializar(resultado)

# NOVA ROTA: Um produto em vários países (Ranking)
@app.get("/analise/produto/{sku}", tags=["Consultas por Abrangência"])
async def analise_por_produto(sku: str):
    """Retorna o ranking de um produto em todos os países."""
    if not engine:
        raise HTTPException(status_code=500, detail="Motor offline.")
    
    # Passamos country_id=None para buscar o produto globalmente
    resultado = engine.get_full_analysis(sku=sku, country_id=None)
    return serializar(resultado)

@app.get("/analise/detalhada/{country_id}/{sku}", tags=["Consultas Específicas"])
async def obter_analise_detalhada(country_id: int, sku: str):
    if not engine:
        raise HTTPException(status_code=500, detail="Motor offline.")

    resultado = engine.get_full_analysis(sku, country_id)
    
    # Verifica se o resultado é um erro antes de serializar
    if isinstance(resultado, dict) and resultado.get("status") == "error":
        raise HTTPException(status_code=404, detail=resultado.get("message"))
        
    return serializar(resultado)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)