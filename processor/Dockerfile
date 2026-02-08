FROM python:3.11-slim

WORKDIR /app

# Dependências de sistema
RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

# Instala as libs
COPY ./processor/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia todo o projeto para dentro do container
COPY . .

# Expõe a porta do FastAPI
EXPOSE 8000

# ATENÇÃO: Agora apontamos para o arquivo da ROOT (supondo que ele se chame main.py ou api.py)
# Se o arquivo se chamar 'api_main.py', mude abaixo:
CMD ["python", "app.py"]