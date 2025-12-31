#!/bin/bash
set -e

# Este comando psql usa as variáveis que estão no arquivo .env
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    ALTER USER pc_data_writer WITH PASSWORD '$WRITER_PASSWORD';
    ALTER USER pc_api_reader WITH PASSWORD '$READER_PASSWORD';
EOSQL