INSERT INTO products (sku, product_name, search_code, search_term, id_category)
VALUES 
    -- Eletrônicos (Cat 1)
    ('IPHONE_15_128', 'iPhone 15 Apple 128GB', 'B0CHX2F5QT', 'Apple iPhone 15 128GB Black', 1),
    ('PS5_DISC', 'PlayStation 5 Console', 'B0CL61HW92', 'PlayStation 5 Console Disc Edition', 1),
    ('LOGITECH_MX_3S', 'Mouse Logitech MX Master 3S', 'B09HM94VDS', 'Logitech MX Master 3S Wireless Mouse', 1),

    -- Saúde e Cuidados (Cat 3)
    ('GLUCOMETER_GUIDE', 'Medidor Accu-Chek Guide', 'B01M3X0N89', 'Accu-Chek Guide Blood Glucose Meter', 3),
    ('THERMOMETER_BRAUN', 'Termômetro Braun ThermoScan 7', 'B00MUK6M82', 'Braun ThermoScan 7 Digital Ear Thermometer', 3),
    ('ORALB_PRO1000', 'Escova Elétrica Oral-B Pro 1000', 'B01AKGRTUM', 'Oral-B Pro 1000 CrossAction', 3),

    -- Alimentos e Bebidas (Cat 4)
    ('NESPRESSO_ARPEGGIO', 'Cápsulas Nespresso Arpeggio 10un', 'B008IDY8S6', 'Nespresso Arpeggio Capsules 10 count', 4),

    -- Casa e Eletro (Cat 2)
    ('STANLEY_QUENCHER', 'Copo Stanley Quencher 1.1L', 'B0BSM6956S', 'Stanley Quencher H2.0 FlowState 40oz', 2),

    -- Beleza e Perfumaria (Cat 6)
    ('DOVE_BAR_6', 'Sabonete Dove Original 6un', 'B005HO0AUI', 'Dove Beauty Bar Original White 6 Count', 6),

    -- Brinquedos e Jogos (Cat 7)
    ('MARIO_WONDER_NSW', 'Super Mario Bros. Wonder - Switch', 'B0C9R8B69H', 'Super Mario Bros. Wonder Nintendo Switch Standard Edition', 7),
    ('SPIDERMAN_2_PS5', 'Marvel’s Spider-Man 2 - PS5', 'B0C7S7SLBN', 'Marvel’s Spider-Man 2 PlayStation 5', 7)
    
   

ON CONFLICT (sku) DO UPDATE SET 
    id_category = EXCLUDED.id_category,
    search_code = EXCLUDED.search_code,
    search_term = EXCLUDED.search_term;