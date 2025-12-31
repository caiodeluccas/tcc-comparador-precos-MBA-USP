# 1. Imagem base leve do Python
FROM python:3.11-slim

# 2. Instala dependências do sistema para o psycopg2 e outras libs
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 3. Define a pasta de trabalho dentro do container
WORKDIR /app

# 4. Copia o arquivo de requisitos primeiro (melhora o cache do Docker)
COPY requirements.txt .

# 5. Instala as dependências do Python
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copia todo o código da pasta local para o container
COPY . .

# 7. Comando para rodar o script principal
CMD ["python", "main.py"]