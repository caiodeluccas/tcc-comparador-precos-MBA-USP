ALTER ROLE pc_admin_user SET search_path TO public;

-- Tabela de referência para os países
CREATE TABLE IF NOT EXISTS countries (
    id_country SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL UNIQUE,
    native_name VARCHAR(100),
    continent VARCHAR(50) NOT NULL,
    iso_2_code CHAR(2) NOT NULL UNIQUE,
    iso_3_code CHAR(3) NOT NULL UNIQUE,
    base_currency CHAR(3) NOT NULL
);

-- Tabela de tradução para internacionalização dos nomes dos países
CREATE TABLE IF NOT EXISTS country_translations (
    id_translation SERIAL PRIMARY KEY,
    id_country INTEGER NOT NULL,
    language_code CHAR(5) NOT NULL,
    translated_name VARCHAR(255) NOT NULL,
    
    CONSTRAINT fk_translation_country
        FOREIGN KEY (id_country) REFERENCES countries(id_country) ON DELETE CASCADE,
    CONSTRAINT unique_country_language 
        UNIQUE(id_country, language_code)
);

-- Categorias de produtos
CREATE TABLE IF NOT EXISTS categories (
    id_category SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- Cadastro de produtos
CREATE TABLE IF NOT EXISTS products (
    sku VARCHAR(255) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    id_category INTEGER NOT NULL,

    CONSTRAINT fk_product_category
        FOREIGN KEY (id_category) REFERENCES categories(id_category)
);

-- Fontes de dados (Ex: ILO, Yahoo Finance, etc)
CREATE TABLE IF NOT EXISTS sources (
    id_source SERIAL PRIMARY KEY,
    source_name VARCHAR(100) NOT NULL UNIQUE
);

-- Histórico de preços e salários coletados
CREATE TABLE IF NOT EXISTS price_history (
    id_history BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sku VARCHAR(255) NOT NULL,
    id_source INTEGER NOT NULL,
    id_country INTEGER NOT NULL,
    price NUMERIC(15, 2) NOT NULL,
    currency CHAR(3) NOT NULL,
    collection_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_salary_year UNIQUE (id_country, id_indicator, reference_year),

    CONSTRAINT fk_history_product
        FOREIGN KEY (sku) REFERENCES products(sku),
    CONSTRAINT fk_history_source
        FOREIGN KEY (id_source) REFERENCES sources(id_source),
    CONSTRAINT fk_history_country
        FOREIGN KEY (id_country) REFERENCES countries(id_country)
);

-- Tabela de indicadores (O catálogo do que você pode coletar)
CREATE TABLE IF NOT EXISTS salary_indicators (
    id_indicator SERIAL PRIMARY KEY,
    indicator_code VARCHAR(50) NOT NULL UNIQUE, -- Ex: EAR_4MTH_AVE
    description VARCHAR(255),                   -- Ex: Salário médio mensal
    unit VARCHAR(20)                            -- Ex: Horas, Dias, Meses
);

-- Tabela de histórico (Onde os valores reais moram)
CREATE TABLE IF NOT EXISTS salary_history (
    id_salary BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_country INTEGER NOT NULL,
    id_indicator INTEGER NOT NULL,
    id_source INTEGER NOT NULL,
    salary_value NUMERIC(15, 2) NOT NULL,
    currency CHAR(3) NOT NULL,
    reference_year INTEGER NOT NULL,
    collection_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_salary_country FOREIGN KEY (id_country) REFERENCES countries(id_country),
    CONSTRAINT fk_salary_indicator FOREIGN KEY (id_indicator) REFERENCES salary_indicators(id_indicator),
    CONSTRAINT fk_salary_source FOREIGN KEY (id_source) REFERENCES sources(id_source)
);


-- Tabela de taxas de câmbio
CREATE TABLE IF NOT EXISTS exchange_rates (
    id_exchange SERIAL PRIMARY KEY,
    id_country_origin INTEGER NOT NULL,
    target_currency CHAR(3) NOT NULL,
    exchange_rate NUMERIC(12, 6) NOT NULL,
    quote_date DATE DEFAULT CURRENT_DATE,

    CONSTRAINT fk_exchange_country_origin
        FOREIGN KEY (id_country_origin) REFERENCES countries(id_country)
);

-- Tabelas de staging
CREATE TABLE IF NOT EXISTS staging_salary (
    iso_3_code CHAR(3),
    indicator_code TEXT,
    salary_value NUMERIC,
    reference_year INTEGER,
    currency CHAR(3)
);
