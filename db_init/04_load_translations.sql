-- 1. Cria a tabela temporária para as traduções
CREATE TEMP TABLE temp_translations_pt (
    iso_code CHAR(2),
    portuguese_name VARCHAR(255)
);

-- 2. Carrega o arquivo CSV
COPY temp_translations_pt (iso_code, portuguese_name)
FROM '/docker-entrypoint-initdb.d/country_translate_pt.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- 3. Insere na tabela oficial fazendo o JOIN com a tabela de países já existente
INSERT INTO country_translations (id_country, language_code, translated_name)
SELECT 
    c.id_country, 
    'pt-br', 
    t.portuguese_name
FROM countries c
JOIN temp_translations_pt t ON c.iso_2_code = t.iso_code
ON CONFLICT (id_country, language_code) DO NOTHING;

-- 4. Limpa a tabela temporária
DROP TABLE temp_translations_pt;