-- Arquivo: ./db_init/03_load_countries.sql

-- 1. Limpa a tabela
-- O CASCADE garante que limpa mesmo que existam chaves estrangeiras
TRUNCATE TABLE countries CASCADE;

-- 2. Cria a tabela temporária
CREATE TEMP TABLE temp_countries_load(
    iso_2_key CHAR(2),
    country_name VARCHAR(255),
    native_name TEXT,
    phone_code TEXT,
    continent_code CHAR(2),
    capital_name TEXT,
    base_currency CHAR(3)
);

-- 3. Copia os dados do CSV
COPY temp_countries_load (iso_2_key, country_name, native_name, phone_code, continent_code, capital_name, base_currency)
FROM '/docker-entrypoint-initdb.d/countries.csv'
DELIMITER ','
CSV HEADER;

-- 4. Insere na tabela final
INSERT INTO countries (iso_2_code, common_name, native_name, continent, base_currency)
SELECT 
    iso_2_key,    -- Nome da coluna na temp
    country_name, -- Nome da coluna na temp
    native_name,  -- Nome da coluna na temp
    continent_code, -- Nome da coluna na temp
    base_currency   -- Nome da coluna na temp
FROM temp_countries_load;

-- Limpa a temp após o uso
DROP TABLE temp_countries_load;

