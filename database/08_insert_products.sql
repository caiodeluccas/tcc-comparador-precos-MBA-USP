-- 1. Inserindo os produtos
INSERT INTO products (sku, product_name, search_term, id_category)
VALUES
    ('COCA_ZERO_12P',      'Coca-Cola Zero Sugar (12 Pack)', 'Coca-Cola Zero Sugar 12 Pack', 2),
    ('COCA_ZERO_24P',      'Coca-Cola Zero Sugar (24 Pack)', 'Coca-Cola Zero Sugar 24 Pack', 2),
    ('HAVAIANAS_TOP',      'Havaianas Top',                  'Havaianas Top',                  5),
    ('LEGO_CLASSIC_10698', 'LEGO Classic 10698',             'LEGO Classic 10698',             7),
    ('AIRPODS_PRO_3',      'Apple AirPods Pro 3',            'Apple AirPods Pro 3',            1);

COMMIT;

-- 2. Mapeamento de ASINs
INSERT INTO product_asins (sku, id_country, search_code)
VALUES
    -- COCA 12P
    ('COCA_ZERO_12P', (SELECT id_country FROM countries WHERE iso_3_code = 'BRA'), 'B0CKWDGDXJ'),
    ('COCA_ZERO_12P', (SELECT id_country FROM countries WHERE iso_3_code = 'USA'), 'B000OV0S84'),
    ('COCA_ZERO_12P', (SELECT id_country FROM countries WHERE iso_3_code = 'ESP'), 'B004MIB4OW'),

    -- COCA 24P
    ('COCA_ZERO_24P', (SELECT id_country FROM countries WHERE iso_3_code = 'JPN'), 'B001SES0DQ'),
    ('COCA_ZERO_24P', (SELECT id_country FROM countries WHERE iso_3_code = 'IND'), 'B0839JSQ62'),

    -- HAVAIANAS
    ('HAVAIANAS_TOP', (SELECT id_country FROM countries WHERE iso_3_code = 'BRA'), 'B000YKO2LE'),
    ('HAVAIANAS_TOP', (SELECT id_country FROM countries WHERE iso_3_code = 'USA'), 'B000YKO2LE'),
    ('HAVAIANAS_TOP', (SELECT id_country FROM countries WHERE iso_3_code = 'ESP'), 'B09XJH7V2Y'),
    ('HAVAIANAS_TOP', (SELECT id_country FROM countries WHERE iso_3_code = 'JPN'), 'B076B5W92X'),
    ('HAVAIANAS_TOP', (SELECT id_country FROM countries WHERE iso_3_code = 'IND'), 'B003AOP0V2'),

    -- LEGO
    ('LEGO_CLASSIC_10698', (SELECT id_country FROM countries WHERE iso_3_code = 'USA'), 'B00NHQF6MG'),
    ('LEGO_CLASSIC_10698', (SELECT id_country FROM countries WHERE iso_3_code = 'BRA'), 'B07MMHRVX6'),
    ('LEGO_CLASSIC_10698', (SELECT id_country FROM countries WHERE iso_3_code = 'ESP'), 'B00PY3EYQO'),
    ('LEGO_CLASSIC_10698', (SELECT id_country FROM countries WHERE iso_3_code = 'JPN'), 'B00PY3EYQO'),
    ('LEGO_CLASSIC_10698', (SELECT id_country FROM countries WHERE iso_3_code = 'IND'), 'B00PY3EYQO'),

    -- AIRPODS
    ('AIRPODS_PRO_3', (SELECT id_country FROM countries WHERE iso_3_code = 'BRA'), 'B0FQGMGVCT'),
    ('AIRPODS_PRO_3', (SELECT id_country FROM countries WHERE iso_3_code = 'USA'), 'B0FQFB8FMG'),
    ('AIRPODS_PRO_3', (SELECT id_country FROM countries WHERE iso_3_code = 'ESP'), 'B0FQF32239'),
    ('AIRPODS_PRO_3', (SELECT id_country FROM countries WHERE iso_3_code = 'JPN'), 'B0FQFQDN6K'),
    ('AIRPODS_PRO_3', (SELECT id_country FROM countries WHERE iso_3_code = 'IND'), 'B0FQFJBBVY');

COMMIT;