-- =================================================================
-- CRIAR OS BANCOS DE DADOS SEPARADOS PARA CADA APLICAÇÃO
-- =================================================================
-- O usuário e a senha são pegos das variáveis de ambiente POSTGRES_USER e POSTGRES_PASSWORD
SELECT 'CREATE DATABASE n8n_db' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'n8n_db')\gexec
SELECT 'CREATE DATABASE evolution_db' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'evolution_db')\gexec
SELECT 'CREATE DATABASE gersys_eventos_db' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'gersys_eventos_db')\gexec

-- =================================================================
-- CONECTAR AO BANCO
-- =================================================================
\c gersys_eventos_db;

-- =================================================================
-- TABELA PARTICIPANTES (usuários)
-- =================================================================
CREATE TABLE participantes (
    id SERIAL PRIMARY KEY,
    status INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(254) NOT NULL,
    telefone VARCHAR(15)
);

-- =================================================================
-- TABELA EVENTOS
-- =================================================================
CREATE TABLE eventos (
    id SERIAL PRIMARY KEY,
    status INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nome VARCHAR(100) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    local VARCHAR(100),
    numero_de_vagas INT,
    publico_alvo VARCHAR(100),
    observacao VARCHAR(255)
);

-- =================================================================
-- TABELA INSCRIÇÕES (participante inscrito em evento)
-- =================================================================
CREATE TABLE inscricoes (
    id SERIAL PRIMARY KEY,
    status INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_participante INT REFERENCES participantes(id) ON DELETE CASCADE,
    id_evento INT REFERENCES eventos(id) ON DELETE CASCADE,
    inscrito BOOLEAN DEFAULT TRUE
);

-- =================================================================
-- TABELA FREQUÊNCIA (lista de presença)
-- =================================================================
CREATE TABLE frequencias (
    id SERIAL PRIMARY KEY,
    status INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_evento INT REFERENCES eventos(id) ON DELETE CASCADE,
    data DATE NOT NULL,
    hora_entrada TIME,
    hora_saida TIME
);

CREATE TABLE frequencia_participantes (
    id SERIAL PRIMARY KEY,
    status INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_frequencia INT REFERENCES frequencias(id) ON DELETE CASCADE,
    id_participante INT REFERENCES participantes(id) ON DELETE CASCADE,
    presente BOOLEAN DEFAULT TRUE,
    justificativa VARCHAR(255)
);

-- =================================================================
-- PERMISSÕES
-- =================================================================
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "user";
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO "user";
