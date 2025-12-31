-- 1. Criação dos Usuários (Sem senha aqui, o script .sh cuidará disso)
CREATE USER pc_data_writer;
CREATE USER pc_api_reader;

-- 2. Permissões para o Usuário de ESCRITA (Coletor)
GRANT CONNECT ON DATABASE price_comp TO pc_data_writer;
GRANT USAGE ON SCHEMA public TO pc_data_writer;
GRANT INSERT, SELECT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO pc_data_writer;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO pc_data_writer;

-- 3. Permissões para o Usuário de LEITURA (API/Dashboard)
GRANT CONNECT ON DATABASE price_comp TO pc_api_reader;
GRANT USAGE ON SCHEMA public TO pc_api_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO pc_api_reader;

-- 4. Garantir que tabelas criadas no futuro também sigam essas regras
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO pc_data_writer;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO pc_api_reader;