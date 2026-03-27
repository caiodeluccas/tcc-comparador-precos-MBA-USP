-- Tabela de referência para os países
CREATE TABLE IF NOT EXISTS countries (
    id_country SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL UNIQUE,
    native_name VARCHAR(100),
    continent VARCHAR(50) NOT NULL,
    iso_2_code CHAR(2) NOT NULL UNIQUE,
    iso_3_code CHAR(3) NOT NULL UNIQUE,
    base_unit_label CHAR(3) NOT NULL
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
    search_term VARCHAR(255), 
    description TEXT,
    id_category INTEGER NOT NULL,
    CONSTRAINT fk_product_category FOREIGN KEY (id_category) REFERENCES categories(id_category)
);

-- Fontes de dados (Ex: ILO, Yahoo Finance, etc)
CREATE TABLE IF NOT EXISTS sources (
    id_source SERIAL PRIMARY KEY,
    source_name VARCHAR(100) NOT NULL UNIQUE
);

-- Histórico de preços e coletados
CREATE TABLE IF NOT EXISTS price_history (
    id_history BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sku VARCHAR(255) NOT NULL,
    id_source INTEGER NOT NULL,
    id_country INTEGER NOT NULL,
    price NUMERIC(15, 2) NOT NULL,
    unit_label CHAR(3) NOT NULL,
    collection_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_product_price_unique UNIQUE (sku, id_country, id_source, collection_timestamp),

    CONSTRAINT fk_history_product
        FOREIGN KEY (sku) REFERENCES products(sku),
    CONSTRAINT fk_history_source
        FOREIGN KEY (id_source) REFERENCES sources(id_source),
    CONSTRAINT fk_history_country
        FOREIGN KEY (id_country) REFERENCES countries(id_country)
);

-- Tabela de indicadores (O catálogo do que você pode coletar)
CREATE TABLE IF NOT EXISTS labor_indicators (
    id_indicator SERIAL PRIMARY KEY,
    indicator_code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    unit VARCHAR(20),
    id_source INTEGER REFERENCES sources(id_source) -- Nova coluna com chave estrangeira
);

-- Tabela de histórico (Onde os valores reais moram)
CREATE TABLE IF NOT EXISTS labor_indicators_history (
    id_salary BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_country INTEGER NOT NULL,
    id_indicator INTEGER NOT NULL,
    id_source INTEGER NOT NULL,
    indicator_value NUMERIC(15, 2) NOT NULL,
    unit_label CHAR(3) NOT NULL,
    reference_year INTEGER NOT NULL,
    collection_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_labor_country FOREIGN KEY (id_country) REFERENCES countries(id_country),
    CONSTRAINT fk_labor_indicator FOREIGN KEY (id_indicator) REFERENCES labor_indicators(id_indicator),
    CONSTRAINT fk_labor_source FOREIGN KEY (id_source) REFERENCES sources(id_source),
    
    CONSTRAINT uq_labor_entry UNIQUE (id_country, id_indicator, reference_year)
);


-- Tabela de mapeamento
CREATE TABLE IF NOT EXISTS product_asins (
    sku VARCHAR(255) REFERENCES products(sku),
    id_country INT REFERENCES countries(id_country),
    search_code VARCHAR(50) NOT NULL,
    PRIMARY KEY (sku, id_country)
);



-- Tabelas de staging
CREATE TABLE IF NOT EXISTS staging_labor_indicators (
    iso_3_code CHAR(3),
    indicator_code TEXT,
    indicator_value NUMERIC,
    reference_year INTEGER,
    unit_label CHAR(3)
);


