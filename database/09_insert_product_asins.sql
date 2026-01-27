INSERT INTO products (sku, product_name, search_term, id_category)
VALUES 
    ('IPHONE_17_PRO_MAX', 'Apple iPhone 17 Pro Max (256 GB)', 'Apple iPhone 17 Pro Max Azul Intenso', 1),
    ('PS5_DISC', 'PlayStation 5 Console', 'PlayStation 5 Console Disc Edition', 1)
ON CONFLICT (sku) DO UPDATE SET 
    id_category = EXCLUDED.id_category,
    product_name = EXCLUDED.product_name,
    search_term = EXCLUDED.search_term;