-- 1. Cria a tabela temporária
CREATE TEMP TABLE temp_translations_pt (
    iso_code CHAR(2),
    portuguese_name VARCHAR(255)
);

-- 2. Carrega o arquivo (Certifique-se que o nome do arquivo na pasta é EXATAMENTE esse)
COPY temp_translations_pt (iso_code, portuguese_name)
FROM '/docker-entrypoint-initdb.d/country_translate_pt.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- 3. Insere na tabela oficial
INSERT INTO country_translations (id_country, language_code, translated_name)
SELECT 
    c.id_country, 
    'pt-br', 
    t.portuguese_name
FROM countries c
JOIN temp_translations_pt t ON c.iso_2_code = t.iso_code
ON CONFLICT (id_country, language_code) DO NOTHING;

-- 4. Limpa a temporária
DROP TABLE temp_translations_pt;