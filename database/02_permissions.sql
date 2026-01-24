-- Use o nome exato que está no seu .env: price_comp
GRANT CONNECT ON DATABASE price_comp TO pc_data_writer;
GRANT USAGE ON SCHEMA public TO pc_data_writer;
GRANT INSERT, SELECT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA public TO pc_data_writer;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO pc_data_writer;

-- Repita para o leitor
GRANT CONNECT ON DATABASE price_comp TO pc_api_reader;
GRANT USAGE ON SCHEMA public TO pc_api_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO pc_api_reader;