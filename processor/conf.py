# processor/conf.py

# ==========================================================
# MAPEAMENTO DE INDICADORES DOS SALÁRIOS COLETADOS
# ==========================================================
labor_indicators = {
    1: "min_hour",   # Salário Mínimo por Hora
    2: "avg_hour",   # Salário Médio por Hora
    3: "min_month",  # Salário Mínimo por Mês
    4: "avg_month"   # Salário Médio por Mês
}

# ==========================================================
# PARÂMETROS DE QUALIDADE E ANÁLISE (DATA QUALITY)
# ==========================================================
ANALYSIS_CONFIG = {
    "outlier_threshold": 0.60,  # Limite de 60% para variação de preço
    "weeks_window": 4,          # Janela de tempo: últimas 4 semanas
    "min_records_to_validate": 2 # Mínimo de registros para calcular outlier
}

# ==========================================================
# FILTROS DE ESCOPO DO TCC
# ==========================================================
TARGET_COUNTRIES = [1, 5, 10, 15, 20] 

# ==========================================================
# CONFIGURAÇÕES DE CÁLCULO
# Se no futuro você precisar de horas fixas, altere aqui.
# ==========================================
DEFAULT_HOURS_PER_MONTH = 160

# ==========================================================
# Mapeamento de Produtos (SKUs)
# Chave: SKU do banco | Valor: Nome amigável para o Front-end
# ==========================================================
# Mapeamento de Produtos (SKUs)
# Chave: SKU do banco | Valor: Nome amigável para o Front-end
PRODUCT_LIST = {
    "IPHONE_15_128": "iPhone 15 (128GB)",
    "COKE_2L": "Coca-Cola (2 Litros)",
    "MAC_BIG": "Big Mac",
    "NETFLIX_STD": "Netflix Mensal"
}