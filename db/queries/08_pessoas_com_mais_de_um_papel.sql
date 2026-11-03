-- Pergunta: Quem exerceu mais de um papel no mesmo título (por exemplo, dirigiu e atuou)?
-- Recursos: JOIN, GROUP BY, HAVING, STRING_AGG, ORDER BY
-- Parâmetros: nenhum

SELECT p.nome                                     AS pessoa,
       t.nome                                     AS titulo,
       STRING_AGG(pa.papel, ', ' ORDER BY pa.papel) AS papeis,
       COUNT(*)                                   AS qtd_papeis
FROM participacao pa
JOIN pessoa p ON p.codigo = pa.pessoa_codigo
JOIN titulo t ON t.codigo = pa.titulo_codigo
GROUP BY p.codigo, p.nome, t.codigo, t.nome
HAVING COUNT(*) > 1
ORDER BY qtd_papeis DESC, p.nome;
