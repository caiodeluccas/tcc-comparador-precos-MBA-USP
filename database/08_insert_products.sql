-- 1. Inserindo o Produto Pai
INSERT INTO products (sku, product_name, search_term, id_category)
VALUES 
    ('COCA_ZERO_12P', 'Coca-Cola Zero Sugar (12 Pack)', 'Coca-Cola Zero Sugar 12 Pack', 2),
    ('HAVAIANAS_TOP', 'Havaianas Schuhe Top Black', 'Havaianas Top Black', 2)
ON CONFLICT (sku) DO UPDATE SET 
    product_name = EXCLUDED.product_name,
    search_term = EXCLUDED.search_term;

-- 2. Mapeamento de ASINs
INSERT INTO product_asins (sku, id_country, search_code)
VALUES 
    -- Mapeamento Coca-Cola Zero
    ('COCA_ZERO_12P', 1, 'B0CKWDGDXJ'), -- BR
    ('COCA_ZERO_12P', 2, 'B000OV0S84'), -- US
    ('COCA_ZERO_12P', 3, 'B004MIB4OW'), -- ES
    
    -- Mapeamento Havaianas Top Black
    ('HAVAIANAS_TOP', 1, 'B000YKO2LE'), -- BR
    ('HAVAIANAS_TOP', 2, 'B000YKO2LE'), -- US
    ('HAVAIANAS_TOP', 3, 'B09XJH7V2Y')  -- ES
ON CONFLICT (sku, id_country) DO UPDATE SET 
    search_code = EXCLUDED.search_code;