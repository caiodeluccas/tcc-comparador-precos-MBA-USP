FROM python:3.11-slim

WORKDIR /app

# Instala dependências para o Postgres
RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

# Copia e instala requirements
COPY collector/requirements.txt . 
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install fastapi uvicorn pandas psycopg2-binary

# Copia os arquivos do projeto
COPY . .

# Expõe a porta do FastAPI
EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]