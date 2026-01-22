from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

# Importação do seu motor de cálculo
from processor.data_processor import EconomicProcessor

# 1. Inicialização da API
app = FastAPI(
    title="Sistema de Paridade de Preços e Salários",
    description="API para análise de indicadores econômicos e poder de compra (MBA).",
    version="1.0.0"
)

# 2. Configuração de CORS (Essencial para o futuro Frontend)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# 3. Instância única do Processador (mantém a conexão com o banco)
try:
    engine = EconomicProcessor()
except Exception as e:
    print(f"ERRO AO CONECTAR NO BANCO: {e}")
    engine = None

# --- ROTAS DA API ---

@app.get("/", tags=["Healthcheck"])
def home():
    """Verifica se a API está online."""
    return {
        "status": "online",
        "projeto": "MBA - Paridade de Preços",
        "documentacao": "/docs"
    }

@app.get("/relatorio-geral", tags=["Relatórios"])
async def obter_relatorio_geral():
    """
    Gera o JSON completo com todos os países e produtos.
    Ideal para apresentar no pré-projeto.
    """
    if not engine:
        raise HTTPException(status_code=500, detail="Motor de processamento offline.")
    
    try:
        return engine.get_global_report()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro no processamento: {str(e)}")

@app.get("/analise/{country_id}/{sku}", tags=["Consultas Específicas"])
async def obter_analise_detalhada(country_id: int, sku: str):
    """
    Retorna o JSON detalhado de um produto em um país específico.
    Exibe: preço atual, média, se é outlier e índice de paridade.
    """
    if not engine:
        raise HTTPException(status_code=500, detail="Motor de processamento offline.")

    resultado = engine.get_full_analysis(sku, country_id)
    
    if resultado.get("status") == "error":
        raise HTTPException(status_code=404, detail=resultado.get("message"))
        
    return resultado

# 4. Comando para rodar (Uvicorn)
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)