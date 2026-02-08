#!/bin/bash
set -e

## O Docker injeta WRITER_PASSWORD e READER_PASSWORD aqui dentro
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- 1. Cria os usuários primeiro
    CREATE USER pc_data_writer;
    CREATE USER pc_api_reader;

## Define as senhas usando as variáveis que o Docker puxou do .env
    ALTER USER pc_data_writer WITH PASSWORD '$WRITER_PASSWORD';
    ALTER USER pc_api_reader WITH PASSWORD '$READER_PASSWORD';
EOSQL

## Dá permissões de acesso ao banco
    GRANT CONNECT ON DATABASE price_comp TO pc_api_reader;
    GRANT USAGE ON SCHEMA public TO pc_api_reader;
    
## Dá permissão de leitura em TODAS as tabelas atuais e futuras
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO pc_api_reader;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO pc_api_reader;