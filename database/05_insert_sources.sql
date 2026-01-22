INSERT INTO sources (id_source, source_name) 
VALUES 
    (1, 'ILOSTAT API'),
    (2, 'Canopy')
ON CONFLICT (id_source) DO NOTHING;
-- O "ON CONFLICT" evita erro se você rodar o script duas vezes.