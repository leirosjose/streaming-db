-- Pergunta: Quantas contas assinam cada plano e qual a receita mensal de cada um?
-- Recursos: LEFT JOIN, GROUP BY, COUNT, expressão com agregação, ORDER BY
-- Parâmetros: nenhum

SELECT pl.nome                         AS plano,
       pl.preco_mensal,
       COUNT(c.email)                  AS qtd_contas,
       pl.preco_mensal * COUNT(c.email) AS receita_mensal
FROM plano pl
LEFT JOIN conta c ON c.plano_nome = pl.nome
GROUP BY pl.nome, pl.preco_mensal
ORDER BY receita_mensal DESC;
