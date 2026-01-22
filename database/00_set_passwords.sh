#!/bin/bash
set -e

# O Docker injeta WRITER_PASSWORD e READER_PASSWORD aqui dentro
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- 1. Cria os usuários primeiro
    CREATE USER pc_data_writer;
    CREATE USER pc_api_reader;

    -- 2. Define as senhas usando as variáveis que o Docker puxou do .env
    ALTER USER pc_data_writer WITH PASSWORD '$WRITER_PASSWORD';
    ALTER USER pc_api_reader WITH PASSWORD '$READER_PASSWORD';
EOSQL