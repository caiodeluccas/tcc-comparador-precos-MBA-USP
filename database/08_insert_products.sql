-- Limpa para evitar erros de duplicidade em reinicializações
TRUNCATE TABLE product_asins;

-- Insere o mapeamento: SKU | ID_COUNTRY | ASIN
-- Países: 1 = Brasil, 2 = EUA, 3 = Espanha
INSERT INTO product_asins (sku, id_country, search_code)
VALUES 
    -- iPhone 17 Pro Max (ASINs específicos por domínio)
    ('IPHONE_17_PRO_MAX', 1, 'B0FQJ2KJ9X'), -- Amazon BR
    ('IPHONE_17_PRO_MAX', 2, 'B0DGJ9B2T9'), -- Amazon US
    ('IPHONE_17_PRO_MAX', 3, 'B0CHX15PBX'), -- Amazon ES

    -- PlayStation 5 (Exemplo de ASIN que pode ser igual ou diferente)
    ('PS5_DISC', 1, 'B0CL61HW92'), 
    ('PS5_DISC', 2, 'B0CL61HW92'), 
    ('PS5_DISC', 3, 'B0CL61HW92')

ON CONFLICT (sku, id_country) DO UPDATE SET 
    search_code = EXCLUDED.search_code;