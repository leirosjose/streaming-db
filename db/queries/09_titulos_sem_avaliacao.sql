-- Pergunta: Quais títulos nunca foram avaliados?
-- Recursos: subconsulta correlacionada com NOT EXISTS, CASE, ORDER BY
-- Parâmetros: nenhum
--
-- Forma equivalente com LEFT JOIN:
--   FROM titulo t LEFT JOIN avaliacao a ON a.titulo_codigo = t.codigo
--   WHERE a.titulo_codigo IS NULL

SELECT t.codigo,
       t.nome,
       CASE t.tipo WHEN 'F' THEN 'Filme' ELSE 'Série' END AS tipo,
       t.ano_lancamento
FROM titulo t
WHERE NOT EXISTS (
    SELECT 1
    FROM avaliacao a
    WHERE a.titulo_codigo = t.codigo
)
ORDER BY t.nome;
