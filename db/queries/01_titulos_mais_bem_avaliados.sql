-- Pergunta: Quais títulos têm a maior média de nota, entre os que têm pelo menos 2 avaliações?
-- Recursos: JOIN, GROUP BY, HAVING, ORDER BY, funções de agregação (AVG, COUNT)
-- Parâmetros: nenhum

SELECT t.codigo,
       t.nome,
       CASE t.tipo WHEN 'F' THEN 'Filme' ELSE 'Série' END AS tipo,
       ROUND(AVG(a.nota), 2) AS media_nota,
       COUNT(*)              AS qtd_avaliacoes
FROM titulo t
JOIN avaliacao a ON a.titulo_codigo = t.codigo
GROUP BY t.codigo, t.nome, t.tipo
HAVING COUNT(*) >= 2
ORDER BY media_nota DESC, qtd_avaliacoes DESC, t.nome;
