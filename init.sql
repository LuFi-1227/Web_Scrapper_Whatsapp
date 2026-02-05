SELECT 'CREATE DATABASE n8n_db' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'n8n_db')\gexec
SELECT 'CREATE DATABASE evolution_db' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'evolution_db')\gexec
SELECT 'CREATE DATABASE zap_scrapper_db' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'zap_scrapper_db')\gexec

\c zap_scrapper_db;

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    status INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(254) NOT NULL,
    telefone VARCHAR(15)
);

CREATE TABLE noticias (
    id SERIAL PRIMARY KEY,
    status INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    titulo VARCHAR(100) NOT NULL,
    data_publicacao DATE NOT NULL,
    link VARCHAR(100),
    assunto VARCHAR(100),
    resumo VARCHAR(100),
    corpo VARCHAR(500)
);

CREATE TABLE localizacoes (
    id SERIAL PRIMARY KEY,
    status INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT REFERENCES usuarios(id) ON DELETE CASCADE,
    coordenada_latitude FLOAT NOT NULL,
    coordenada_longitude FLOAT NOT NULL,
    nome_local VARCHAR(100)
);

CREATE TABLE noticias_exibidas (
    id SERIAL PRIMARY KEY,
    status INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_noticia INT REFERENCES noticias(id) ON DELETE CASCADE,
    id_usuario INT REFERENCES usuarios(id) ON DELETE CASCADE
);

-- =================================================================
-- PERMISSÕES
-- =================================================================
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "user";
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO "user";
