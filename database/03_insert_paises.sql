-- 1. Limpeza
TRUNCATE TABLE countries CASCADE;

-- 2. Tabela temporária para a linha bruta
CREATE TEMP TABLE raw_countries_data (
    line TEXT
);

-- 3. Carga em modo texto (lê a linha inteira)
COPY raw_countries_data FROM '/docker-entrypoint-initdb.d/countries.csv' WITH (FORMAT text);

-- 4. Inserção com mapeamento manual baseado no seu cabeçalho
INSERT INTO countries (iso_2_code, iso_3_code, common_name, native_name, continent, base_currency)
SELECT 
    split_part(line, ',', 1) as iso2,      -- _key (AD, AE...)
    split_part(line, ',', 2) as iso3,      -- iso3 (AND, ARE...)
    split_part(line, ',', 3) as name,      -- name (Andorra, UAE...)
    split_part(line, ',', 4) as native,    -- native (Andorra, دولة الإمارات...)
    COALESCE(NULLIF(split_part(line, ',', 6), ''), 'NA'), -- continent (EU, AS...)
    split_part(line, ',', 8) as currency   -- currency/0 (EUR, AED...)
FROM raw_countries_data
WHERE line NOT LIKE '_key%'  -- Pula a linha do cabeçalho
  AND line IS NOT NULL 
  AND line <> '';

DROP TABLE raw_countries_data;