-- Pergunta: Quais gêneros têm mais exibições?
-- Recursos: JOIN com COALESCE na condição, GROUP BY, COUNT, COUNT(DISTINCT), ORDER BY
-- Parâmetros: nenhum
--
-- Uma exibição de episódio conta para os gêneros da série. Como
-- filme_codigo e serie_codigo são códigos de titulo, o COALESCE
-- devolve o título da exibição nos dois casos.

SELECT tg.genero_nome                                  AS genero,
       COUNT(*)                                        AS qtd_exibicoes,
       COUNT(DISTINCT e.conta_email || '/' || e.perfil_nome) AS perfis_distintos
FROM exibicao e
JOIN titulo_genero tg
  ON tg.titulo_codigo = COALESCE(e.filme_codigo, e.serie_codigo)
GROUP BY tg.genero_nome
ORDER BY qtd_exibicoes DESC, tg.genero_nome;
