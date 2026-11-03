-- Pergunta: Quais perfis infantis assistiram títulos com classificação acima de 12 anos?
-- Recursos: JOIN entre três tabelas, JOIN com COALESCE, WHERE com IN e booleano, CASE
-- Parâmetros: nenhum

SELECT e.conta_email,
       e.perfil_nome,
       e.data_hora,
       t.nome           AS titulo,
       CASE
           WHEN e.filme_codigo IS NOT NULL THEN 'Filme'
           ELSE 'T' || e.temporada_numero || 'E' || e.episodio_numero
       END              AS conteudo,
       t.classificacao
FROM exibicao e
JOIN perfil p
  ON p.conta_email = e.conta_email
 AND p.nome = e.perfil_nome
JOIN titulo t
  ON t.codigo = COALESCE(e.filme_codigo, e.serie_codigo)
WHERE p.infantil
  AND t.classificacao IN ('14', '16', '18')
ORDER BY e.data_hora;
