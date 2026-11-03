-- Modelo lógico da plataforma de streaming (IMD0401, iteração 2).
-- Roda sozinho na primeira subida do container, antes de 02_views e 03_seed.

CREATE TABLE plano (
    nome              VARCHAR(30)   PRIMARY KEY,
    preco_mensal      NUMERIC(6, 2) NOT NULL CHECK (preco_mensal >= 0),
    qualidade_max     VARCHAR(10)   NOT NULL,
    telas_simultaneas INT           NOT NULL CHECK (telas_simultaneas > 0)
);
COMMENT ON TABLE plano IS 'Entidade Plano do DER.';


CREATE TABLE conta (
    email        VARCHAR(120) PRIMARY KEY,
    senha        VARCHAR(100) NOT NULL,
    data_criacao DATE         NOT NULL DEFAULT CURRENT_DATE,
    rua          VARCHAR(120) NOT NULL,
    numero       VARCHAR(10)  NOT NULL,
    cidade       VARCHAR(60)  NOT NULL,
    estado       CHAR(2)      NOT NULL,
    cep          CHAR(9)      NOT NULL,
    plano_nome   VARCHAR(30)  NOT NULL REFERENCES plano (nome)
);
COMMENT ON TABLE conta IS 'Entidade Conta do DER. O atributo composto endereco virou as colunas rua, numero, cidade, estado e cep. A FK plano_nome implementa o relacionamento Assina.';


CREATE TABLE conta_telefone (
    conta_email VARCHAR(120) NOT NULL REFERENCES conta (email) ON DELETE CASCADE,
    telefone    VARCHAR(20)  NOT NULL,
    PRIMARY KEY (conta_email, telefone)
);
COMMENT ON TABLE conta_telefone IS 'Atributo multivalorado telefone da entidade Conta.';


CREATE TABLE perfil (
    conta_email VARCHAR(120) NOT NULL REFERENCES conta (email) ON DELETE CASCADE,
    nome        VARCHAR(30)  NOT NULL,
    idioma      VARCHAR(10)  NOT NULL DEFAULT 'pt-BR',
    infantil    BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (conta_email, nome)
);
COMMENT ON TABLE perfil IS 'Entidade fraca Perfil, identificada pela Conta (relacionamento Possui). Chave = email da conta + nome do perfil.';


CREATE TABLE titulo (
    codigo         SERIAL       PRIMARY KEY,
    nome           VARCHAR(150) NOT NULL,
    sinopse        TEXT,
    ano_lancamento INT          NOT NULL CHECK (ano_lancamento BETWEEN 1888 AND 2100),
    classificacao  VARCHAR(2)   NOT NULL
                   CHECK (classificacao IN ('L', '10', '12', '14', '16', '18')),
    -- F = filme, S = série
    tipo           CHAR(1)      NOT NULL CHECK (tipo IN ('F', 'S')),
    -- precisa desse UNIQUE para filme e serie poderem referenciar (codigo, tipo)
    CONSTRAINT titulo_codigo_tipo_key UNIQUE (codigo, tipo)
);
COMMENT ON TABLE titulo IS 'Entidade Titulo do DER (superclasse da especialização em Filme e Serie). A coluna tipo indica a subclasse.';


-- Disjunção da especialização: filme tem tipo fixo em 'F' e a FK é
-- (titulo_codigo, tipo), então só entra título marcado como filme. serie faz
-- o mesmo com 'S'. Assim um título não consegue estar nas duas tabelas.
CREATE TABLE filme (
    titulo_codigo INT     PRIMARY KEY,
    tipo          CHAR(1) NOT NULL DEFAULT 'F' CHECK (tipo = 'F'),
    duracao_min   INT     NOT NULL CHECK (duracao_min > 0),
    CONSTRAINT filme_titulo_fkey FOREIGN KEY (titulo_codigo, tipo)
        REFERENCES titulo (codigo, tipo) ON DELETE CASCADE
);
COMMENT ON TABLE filme IS 'Subclasse Filme da especialização de Titulo. A FK (titulo_codigo, tipo) garante a disjunção.';


CREATE TABLE serie (
    titulo_codigo INT     PRIMARY KEY,
    tipo          CHAR(1) NOT NULL DEFAULT 'S' CHECK (tipo = 'S'),
    CONSTRAINT serie_titulo_fkey FOREIGN KEY (titulo_codigo, tipo)
        REFERENCES titulo (codigo, tipo) ON DELETE CASCADE
);
COMMENT ON TABLE serie IS 'Subclasse Serie da especialização de Titulo. A FK (titulo_codigo, tipo) garante a disjunção. O atributo derivado total_temporadas está na view v_serie_temporadas.';


CREATE TABLE temporada (
    serie_codigo INT NOT NULL REFERENCES serie (titulo_codigo) ON DELETE CASCADE,
    numero       INT NOT NULL CHECK (numero > 0),
    PRIMARY KEY (serie_codigo, numero)
);
COMMENT ON TABLE temporada IS 'Entidade fraca Temporada, identificada pela Serie (relacionamento Tem).';


CREATE TABLE episodio (
    serie_codigo     INT          NOT NULL,
    temporada_numero INT          NOT NULL,
    numero           INT          NOT NULL CHECK (numero > 0),
    nome             VARCHAR(150) NOT NULL,
    duracao_min      INT          NOT NULL CHECK (duracao_min > 0),
    PRIMARY KEY (serie_codigo, temporada_numero, numero),
    FOREIGN KEY (serie_codigo, temporada_numero)
        REFERENCES temporada (serie_codigo, numero) ON DELETE CASCADE
);
COMMENT ON TABLE episodio IS 'Entidade fraca Episodio, identificada pela Temporada (relacionamento Contem).';


CREATE TABLE genero (
    nome VARCHAR(30) PRIMARY KEY
);
COMMENT ON TABLE genero IS 'Entidade Genero do DER.';


CREATE TABLE titulo_genero (
    titulo_codigo INT         NOT NULL REFERENCES titulo (codigo) ON DELETE CASCADE,
    genero_nome   VARCHAR(30) NOT NULL REFERENCES genero (nome) ON DELETE CASCADE,
    PRIMARY KEY (titulo_codigo, genero_nome)
);
COMMENT ON TABLE titulo_genero IS 'Relacionamento N:M Pertence entre Titulo e Genero.';


CREATE TABLE pessoa (
    codigo          SERIAL       PRIMARY KEY,
    nome            VARCHAR(100) NOT NULL,
    data_nascimento DATE         NOT NULL
);
COMMENT ON TABLE pessoa IS 'Entidade Pessoa do DER.';


CREATE TABLE participacao (
    pessoa_codigo INT          NOT NULL REFERENCES pessoa (codigo) ON DELETE CASCADE,
    titulo_codigo INT          NOT NULL REFERENCES titulo (codigo) ON DELETE CASCADE,
    papel         VARCHAR(10)  NOT NULL
                  CHECK (papel IN ('diretor', 'roteirista', 'ator')),
    personagem    VARCHAR(100),
    PRIMARY KEY (pessoa_codigo, titulo_codigo, papel),
    -- só ator tem personagem
    CONSTRAINT participacao_personagem_check
        CHECK (papel = 'ator' OR personagem IS NULL)
);
COMMENT ON TABLE participacao IS 'Relacionamento N:M Participa entre Pessoa e Titulo. O atributo multivalorado papel entra na chave primária: uma linha por papel.';


CREATE TABLE avaliacao (
    conta_email   VARCHAR(120) NOT NULL,
    perfil_nome   VARCHAR(30)  NOT NULL,
    titulo_codigo INT          NOT NULL REFERENCES titulo (codigo) ON DELETE CASCADE,
    nota          INT          NOT NULL,
    comentario    TEXT,
    CONSTRAINT avaliacao_pkey PRIMARY KEY (conta_email, perfil_nome, titulo_codigo),
    CONSTRAINT avaliacao_perfil_fkey FOREIGN KEY (conta_email, perfil_nome)
        REFERENCES perfil (conta_email, nome) ON DELETE CASCADE,
    CONSTRAINT avaliacao_nota_check CHECK (nota BETWEEN 1 AND 5)
);
COMMENT ON TABLE avaliacao IS 'Relacionamento N:M Avalia entre Perfil e Titulo, com os atributos nota e comentario.';


CREATE TABLE exibicao (
    conta_email      VARCHAR(120) NOT NULL,
    perfil_nome      VARCHAR(30)  NOT NULL,
    data_hora        TIMESTAMP    NOT NULL,
    ponto_parada_min INT          NOT NULL DEFAULT 0,
    -- ou preenche filme_codigo, ou as três colunas do episódio
    filme_codigo     INT REFERENCES filme (titulo_codigo) ON DELETE CASCADE,
    serie_codigo     INT,
    temporada_numero INT,
    episodio_numero  INT,
    CONSTRAINT exibicao_pkey PRIMARY KEY (conta_email, perfil_nome, data_hora),
    CONSTRAINT exibicao_perfil_fkey FOREIGN KEY (conta_email, perfil_nome)
        REFERENCES perfil (conta_email, nome) ON DELETE CASCADE,
    -- com MATCH FULL não dá pra preencher só parte do episódio (ex: série sem número)
    CONSTRAINT exibicao_episodio_fkey
        FOREIGN KEY (serie_codigo, temporada_numero, episodio_numero)
        REFERENCES episodio (serie_codigo, temporada_numero, numero)
        MATCH FULL ON DELETE CASCADE,
    CONSTRAINT exibicao_ponto_parada_check CHECK (ponto_parada_min >= 0),
    -- cada IS NOT NULL vira 0 ou 1; a soma ser 1 quer dizer filme ou episódio, nunca os dois
    CONSTRAINT exibicao_conteudo_check
        CHECK ((filme_codigo IS NOT NULL)::int + (episodio_numero IS NOT NULL)::int = 1)
);
COMMENT ON TABLE exibicao IS 'Entidade fraca Exibicao, identificada pelo Perfil (relacionamento Registra). Aponta para um filme ou um episódio (relacionamentos Exibe filme e Exibe episodio).';
