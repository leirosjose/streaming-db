-- Dados de exemplo. Títulos e pessoas são reais; contas, perfis, exibições e
-- avaliações foram inventados.

INSERT INTO plano (nome, preco_mensal, qualidade_max, telas_simultaneas) VALUES
    ('Básico',  25.90, 'HD',      1),
    ('Padrão',  39.90, 'Full HD', 2),
    ('Premium', 55.90, '4K',      4);


INSERT INTO conta (email, senha, data_criacao, rua, numero, cidade, estado, cep, plano_nome) VALUES
    ('ana.souza@email.com',      'ana#2026',   '2026-01-10', 'Rua Mossoró',               '512',  'Natal',       'RN', '59020-090', 'Premium'),
    ('carlos.lima@email.com',    'carlos@123', '2026-01-22', 'Avenida Ayrton Senna',      '1840', 'Parnamirim',  'RN', '59151-600', 'Padrão'),
    ('fernanda.alves@email.com', 'fe.alves26', '2026-02-05', 'Rua da Aurora',             '77',   'Recife',      'PE', '50050-000', 'Padrão'),
    ('rafael.costa@email.com',   'rafa2026!',  '2026-02-18', 'Avenida Epitácio Pessoa',   '3021', 'João Pessoa', 'PB', '58039-000', 'Básico');

INSERT INTO conta_telefone (conta_email, telefone) VALUES
    ('ana.souza@email.com',      '(84) 99812-3344'),
    ('ana.souza@email.com',      '(84) 3211-4455'),
    ('carlos.lima@email.com',    '(84) 98705-1122'),
    ('fernanda.alves@email.com', '(81) 99634-7788'),
    ('fernanda.alves@email.com', '(81) 3422-9900'),
    ('rafael.costa@email.com',   '(83) 99187-6655');

INSERT INTO perfil (conta_email, nome, idioma, infantil) VALUES
    ('ana.souza@email.com',      'Ana',      'pt-BR', FALSE),
    ('ana.souza@email.com',      'Bruno',    'pt-BR', FALSE),
    ('ana.souza@email.com',      'Lia',      'pt-BR', TRUE),
    ('carlos.lima@email.com',    'Carlos',   'pt-BR', FALSE),
    ('carlos.lima@email.com',    'Mariana',  'en-US', FALSE),
    ('fernanda.alves@email.com', 'Fernanda', 'pt-BR', FALSE),
    ('fernanda.alves@email.com', 'Theo',     'pt-BR', TRUE),
    ('rafael.costa@email.com',   'Rafael',   'pt-BR', FALSE);


-- códigos fixos pra facilitar os exemplos: 1 a 5 são filmes, 6 a 10 séries
INSERT INTO titulo (codigo, nome, sinopse, ano_lancamento, classificacao, tipo) VALUES
    (1,  'Cidade de Deus',
         'Buscapé cresce na Cidade de Deus, no Rio de Janeiro, e acompanha pela câmera a ascensão do tráfico na comunidade.',
         2002, '16', 'F'),
    (2,  'O Auto da Compadecida',
         'João Grilo e Chicó aplicam golpes no sertão da Paraíba até serem levados a um julgamento diante da Compadecida.',
         2000, '12', 'F'),
    (3,  'Toy Story',
         'O boneco Woody se sente ameaçado quando Buzz Lightyear chega ao quarto de Andy.',
         1995, 'L',  'F'),
    (4,  'Interestelar',
         'Com a Terra ficando sem alimento, um grupo de astronautas atravessa um buraco de minhoca em busca de um novo lar.',
         2014, '10', 'F'),
    (5,  'Tropa de Elite',
         'O capitão Nascimento, do BOPE, precisa encontrar um substituto enquanto enfrenta o tráfico no Rio de Janeiro.',
         2007, '16', 'F'),
    (6,  'Stranger Things',
         'Em Hawkins, nos anos 80, o sumiço de um garoto revela experimentos secretos e uma menina com poderes.',
         2016, '16', 'S'),
    (7,  'Breaking Bad',
         'Um professor de química com câncer passa a fabricar metanfetamina para garantir o futuro da família.',
         2008, '16', 'S'),
    (8,  'Dark',
         'O desaparecimento de crianças em uma cidade alemã expõe segredos de quatro famílias ligadas por viagens no tempo.',
         2017, '16', 'S'),
    (9,  'Avatar: A Lenda de Aang',
         'Aang, o último dobrador de ar, precisa dominar os quatro elementos para acabar com a guerra da Nação do Fogo.',
         2005, 'L',  'S'),
    (10, 'Bluey',
         'Bluey, uma cachorrinha de seis anos, transforma o dia a dia com a família em brincadeiras.',
         2018, 'L',  'S');

-- como o codigo foi passado na mão, a sequência do SERIAL ficou em 1;
-- sem isso o próximo INSERT tentaria o codigo 1 de novo
SELECT setval(pg_get_serial_sequence('titulo', 'codigo'), (SELECT MAX(codigo) FROM titulo));

INSERT INTO filme (titulo_codigo, duracao_min) VALUES
    (1, 130),
    (2, 104),
    (3, 81),
    (4, 169),
    (5, 115);

INSERT INTO serie (titulo_codigo) VALUES (6), (7), (8), (9), (10);

INSERT INTO temporada (serie_codigo, numero) VALUES
    (6, 1), (6, 2),
    (7, 1), (7, 2),
    (8, 1), (8, 2),
    (9, 1), (9, 2),
    (10, 1), (10, 2);

INSERT INTO episodio (serie_codigo, temporada_numero, numero, nome, duracao_min) VALUES
    -- Stranger Things
    (6, 1, 1, 'Chapter One: The Vanishing of Will Byers',     47),
    (6, 1, 2, 'Chapter Two: The Weirdo on Maple Street',      55),
    (6, 1, 3, 'Chapter Three: Holly, Jolly',                  51),
    (6, 2, 1, 'Chapter One: MADMAX',                          48),
    (6, 2, 2, 'Chapter Two: Trick or Treat, Freak',           56),
    (6, 2, 3, 'Chapter Three: The Pollywog',                  51),
    -- Breaking Bad
    (7, 1, 1, 'Pilot',                                        58),
    (7, 1, 2, 'Cat''s in the Bag...',                         48),
    (7, 1, 3, '...And the Bag''s in the River',               48),
    (7, 2, 1, 'Seven Thirty-Seven',                           47),
    (7, 2, 2, 'Grilled',                                      47),
    (7, 2, 3, 'Bit by a Dead Bee',                            47),
    -- Dark
    (8, 1, 1, 'Secrets',                                      51),
    (8, 1, 2, 'Lies',                                         44),
    (8, 1, 3, 'Past and Present',                             45),
    (8, 2, 1, 'Beginnings and Endings',                       52),
    (8, 2, 2, 'Dark Matter',                                  53),
    (8, 2, 3, 'Ghosts',                                       54),
    -- Avatar: A Lenda de Aang
    (9, 1, 1, 'The Boy in the Iceberg',                       23),
    (9, 1, 2, 'The Avatar Returns',                           23),
    (9, 1, 3, 'The Southern Air Temple',                      23),
    (9, 2, 1, 'The Avatar State',                             23),
    (9, 2, 2, 'The Cave of Two Lovers',                       23),
    (9, 2, 3, 'Return to Omashu',                             23),
    -- Bluey
    (10, 1, 1, 'Magic Xylophone',                             7),
    (10, 1, 2, 'Hospital',                                    7),
    (10, 1, 3, 'Keepy Uppy',                                  7),
    (10, 2, 1, 'Dance Mode',                                  7),
    (10, 2, 2, 'Hammerbarn',                                  7),
    (10, 2, 3, 'Featherwand',                                 7);


INSERT INTO genero (nome) VALUES
    ('Ação'), ('Animação'), ('Aventura'), ('Comédia'), ('Crime'),
    ('Drama'), ('Família'), ('Fantasia'), ('Ficção científica'), ('Suspense');

INSERT INTO titulo_genero (titulo_codigo, genero_nome) VALUES
    (1, 'Crime'), (1, 'Drama'),
    (2, 'Comédia'), (2, 'Drama'),
    (3, 'Animação'), (3, 'Comédia'), (3, 'Família'),
    (4, 'Ficção científica'), (4, 'Drama'), (4, 'Aventura'),
    (5, 'Ação'), (5, 'Crime'), (5, 'Drama'),
    (6, 'Ficção científica'), (6, 'Suspense'),
    (7, 'Crime'), (7, 'Drama'), (7, 'Suspense'),
    (8, 'Ficção científica'), (8, 'Suspense'), (8, 'Drama'),
    (9, 'Animação'), (9, 'Aventura'), (9, 'Fantasia'), (9, 'Família'),
    (10, 'Animação'), (10, 'Família'), (10, 'Comédia');


INSERT INTO pessoa (codigo, nome, data_nascimento) VALUES
    (1,  'Fernando Meirelles',   '1955-11-09'),
    (2,  'Matheus Nachtergaele', '1969-01-03'),
    (3,  'Selton Mello',         '1972-12-30'),
    (4,  'Guel Arraes',          '1953-12-12'),
    (5,  'Tom Hanks',            '1956-07-09'),
    (6,  'Christopher Nolan',    '1970-07-30'),
    (7,  'Matthew McConaughey',  '1969-11-04'),
    (8,  'José Padilha',         '1967-08-01'),
    (9,  'Wagner Moura',         '1976-06-27'),
    (10, 'Millie Bobby Brown',   '2004-02-19'),
    (11, 'Bryan Cranston',       '1956-03-07'),
    (12, 'Vince Gilligan',       '1967-02-10');

SELECT setval(pg_get_serial_sequence('pessoa', 'codigo'), (SELECT MAX(codigo) FROM pessoa));

-- pra consulta 08: Guel Arraes, Nolan, Padilha e Vince Gilligan são diretor e
-- roteirista no mesmo título, e Bryan Cranston é ator e diretor em Breaking Bad
INSERT INTO participacao (pessoa_codigo, titulo_codigo, papel, personagem) VALUES
    (1,  1, 'diretor',    NULL),
    (2,  1, 'ator',       'Sandro Cenoura'),
    (2,  2, 'ator',       'João Grilo'),
    (3,  2, 'ator',       'Chicó'),
    (4,  2, 'diretor',    NULL),
    (4,  2, 'roteirista', NULL),
    (5,  3, 'ator',       'Woody'),
    (6,  4, 'diretor',    NULL),
    (6,  4, 'roteirista', NULL),
    (7,  4, 'ator',       'Cooper'),
    (8,  5, 'diretor',    NULL),
    (8,  5, 'roteirista', NULL),
    (9,  5, 'ator',       'Capitão Nascimento'),
    (10, 6, 'ator',       'Onze'),
    (11, 7, 'ator',       'Walter White'),
    (11, 7, 'diretor',    NULL),
    (12, 7, 'diretor',    NULL),
    (12, 7, 'roteirista', NULL);


-- Carlos viu o piloto de Breaking Bad duas vezes (01/04 e 02/04). É por isso
-- que Exibição é entidade com data_hora na chave, e não um relacionamento.
INSERT INTO exibicao (conta_email, perfil_nome, data_hora, ponto_parada_min,
                      filme_codigo, serie_codigo, temporada_numero, episodio_numero) VALUES
    ('ana.souza@email.com',      'Ana',      '2026-03-02 20:10', 169, 4,    NULL, NULL, NULL),
    ('ana.souza@email.com',      'Ana',      '2026-03-05 21:00',  51, NULL, 8,    1,    1),
    ('ana.souza@email.com',      'Ana',      '2026-03-06 21:30',  44, NULL, 8,    1,    2),
    ('ana.souza@email.com',      'Ana',      '2026-03-07 22:00',  30, NULL, 8,    1,    3),
    ('ana.souza@email.com',      'Bruno',    '2026-03-03 19:00', 115, 5,    NULL, NULL, NULL),
    ('ana.souza@email.com',      'Bruno',    '2026-03-10 20:00',  58, NULL, 7,    1,    1),
    ('ana.souza@email.com',      'Bruno',    '2026-03-11 20:30',  25, NULL, 7,    1,    2),
    ('ana.souza@email.com',      'Lia',      '2026-03-04 10:00',   7, NULL, 10,   1,    1),
    ('ana.souza@email.com',      'Lia',      '2026-03-04 10:10',   7, NULL, 10,   1,    2),
    ('ana.souza@email.com',      'Lia',      '2026-03-08 15:00',  60, 3,    NULL, NULL, NULL),
    ('ana.souza@email.com',      'Lia',      '2026-03-09 16:00',  12, NULL, 6,    1,    1),
    ('carlos.lima@email.com',    'Carlos',   '2026-04-01 21:00',  20, NULL, 7,    1,    1),
    ('carlos.lima@email.com',    'Carlos',   '2026-04-02 21:00',  58, NULL, 7,    1,    1),
    ('carlos.lima@email.com',    'Carlos',   '2026-04-03 22:00',  48, NULL, 7,    1,    2),
    ('carlos.lima@email.com',    'Carlos',   '2026-04-10 20:00', 130, 1,    NULL, NULL, NULL),
    ('carlos.lima@email.com',    'Mariana',  '2026-04-05 19:30', 104, 2,    NULL, NULL, NULL),
    ('carlos.lima@email.com',    'Mariana',  '2026-04-06 20:00',  47, NULL, 6,    1,    1),
    ('carlos.lima@email.com',    'Mariana',  '2026-04-07 20:00',  33, NULL, 6,    1,    2),
    ('fernanda.alves@email.com', 'Fernanda', '2026-05-01 21:00',  47, NULL, 6,    1,    1),
    ('fernanda.alves@email.com', 'Fernanda', '2026-05-02 21:00',  95, 4,    NULL, NULL, NULL),
    ('fernanda.alves@email.com', 'Theo',     '2026-05-03 09:00',  23, NULL, 9,    1,    1),
    ('fernanda.alves@email.com', 'Theo',     '2026-05-03 09:30',  23, NULL, 9,    1,    2),
    ('fernanda.alves@email.com', 'Theo',     '2026-05-04 09:00',  10, NULL, 9,    1,    3),
    ('fernanda.alves@email.com', 'Theo',     '2026-05-05 18:00',  15, NULL, 8,    1,    1),
    ('rafael.costa@email.com',   'Rafael',   '2026-05-10 22:00',  80, 1,    NULL, NULL, NULL);


INSERT INTO avaliacao (conta_email, perfil_nome, titulo_codigo, nota, comentario) VALUES
    ('ana.souza@email.com',      'Ana',      4,  5, 'Chorei na cena das mensagens. Que trilha sonora.'),
    ('ana.souza@email.com',      'Ana',      3,  5, 'Revi com a Lia e continua ótimo.'),
    ('ana.souza@email.com',      'Bruno',    7,  3, 'Começo lento demais pra mim, parei no segundo episódio.'),
    ('ana.souza@email.com',      'Bruno',    1,  4, 'Pesado em algumas cenas, mas muito bem feito.'),
    ('ana.souza@email.com',      'Lia',      10, 5, 'Muito engraçado!'),
    ('ana.souza@email.com',      'Lia',      3,  4, 'O Buzz é o melhor.'),
    ('carlos.lima@email.com',    'Carlos',   7,  5, 'Vi o piloto duas vezes. Melhor série que já assisti.'),
    ('carlos.lima@email.com',    'Carlos',   1,  5, 'Obrigatório pra qualquer brasileiro.'),
    ('carlos.lima@email.com',    'Mariana',  2,  5, 'Não sei, só sei que foi assim.'),
    ('carlos.lima@email.com',    'Mariana',  6,  3, 'Legal, mas achei o segundo episódio arrastado.'),
    ('fernanda.alves@email.com', 'Fernanda', 4,  4, 'Bonito, mas a parte de física me perdeu um pouco.'),
    ('fernanda.alves@email.com', 'Fernanda', 6,  4, 'Nostalgia dos anos 80 bem feita.'),
    ('fernanda.alves@email.com', 'Theo',     9,  5, 'O Aang é muito legal.'),
    ('rafael.costa@email.com',   'Rafael',   1,  4, 'Forte, mas é cinema de verdade.'),
    ('rafael.costa@email.com',   'Rafael',   2,  5, 'Revi pela décima vez e ainda rio do Chicó.');
