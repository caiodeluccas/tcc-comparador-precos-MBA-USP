INSERT INTO categories (id_category, category_name) VALUES 
    (1, 'Eletrônicos e Informática'),
    (2, 'Eletrodomésticos e Casa'),
    (3, 'Saúde e Cuidados Pessoais'),
    (4, 'Alimentos e Bebidas'),
    (5, 'Moda e Acessórios'),
    (6, 'Beleza e Perfumaria'),
    (7, 'Brinquedos e Jogos'),
    (8, 'Esporte e Lazer'),
    (9, 'Livros e Mídia'),
    (10, 'Automotivo')
ON CONFLICT (id_category) DO NOTHING;