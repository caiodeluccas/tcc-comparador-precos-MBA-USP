#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- 1. Cria os usuários
    CREATE USER pc_data_writer;
    CREATE USER pc_api_reader;

    -- 2. Define as senhas
    ALTER USER pc_data_writer WITH PASSWORD '$WRITER_PASSWORD';
    ALTER USER pc_api_reader WITH PASSWORD '$READER_PASSWORD';

    -- 3. Permissões
    GRANT CONNECT ON DATABASE price_comp TO pc_api_reader;
    GRANT USAGE ON SCHEMA public TO pc_api_reader;
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO pc_api_reader;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO pc_api_reader;
EOSQL