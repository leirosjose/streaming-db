-- Pergunta: Quem participou de um título, com qual papel e qual personagem?
-- Recursos: JOIN entre três tabelas, WHERE com parâmetro, ORDER BY com CASE
-- Parâmetros:
--   codigo = 7

SELECT t.nome  AS titulo,
       p.nome  AS pessoa,
       pa.papel,
       pa.personagem
FROM participacao pa
JOIN pessoa p ON p.codigo = pa.pessoa_codigo
JOIN titulo t ON t.codigo = pa.titulo_codigo
WHERE t.codigo = %(codigo)s
ORDER BY CASE pa.papel
             WHEN 'diretor'    THEN 1
             WHEN 'roteirista' THEN 2
             ELSE 3
         END,
         p.nome;
