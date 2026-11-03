-- total_temporadas é atributo derivado no DER, então é calculado aqui em vez
-- de ficar guardado em serie. LEFT JOIN para série sem temporada aparecer com 0.
CREATE VIEW v_serie_temporadas AS
SELECT s.titulo_codigo   AS serie_codigo,
       t.nome            AS serie,
       COUNT(tp.numero)  AS total_temporadas
FROM serie s
JOIN titulo t ON t.codigo = s.titulo_codigo
LEFT JOIN temporada tp ON tp.serie_codigo = s.titulo_codigo
GROUP BY s.titulo_codigo, t.nome;

COMMENT ON VIEW v_serie_temporadas IS 'Atributo derivado total_temporadas de Serie.';


-- título sem avaliação aparece com média nula e quantidade 0
CREATE VIEW v_titulo_avaliacao AS
SELECT t.codigo,
       t.nome,
       t.tipo,
       ROUND(AVG(a.nota), 2) AS media_nota,
       COUNT(a.nota)         AS qtd_avaliacoes
FROM titulo t
LEFT JOIN avaliacao a ON a.titulo_codigo = t.codigo
GROUP BY t.codigo, t.nome, t.tipo;

COMMENT ON VIEW v_titulo_avaliacao IS 'Média de nota e quantidade de avaliações por título.';


-- Um perfil pode ver o mesmo conteúdo várias vezes. O ROW_NUMBER numera as
-- exibições de cada perfil + conteúdo da mais recente pra mais antiga, e o
-- WHERE ordem = 1 fica só com a última.
CREATE VIEW v_continuar_assistindo AS
WITH ultima AS (
    SELECT e.*,
           ROW_NUMBER() OVER (
               PARTITION BY e.conta_email, e.perfil_nome,
                            e.filme_codigo, e.serie_codigo,
                            e.temporada_numero, e.episodio_numero
               ORDER BY e.data_hora DESC
           ) AS ordem
    FROM exibicao e
)
SELECT u.conta_email,
       u.perfil_nome,
       u.data_hora,
       CASE WHEN u.filme_codigo IS NOT NULL THEN 'Filme' ELSE 'Episódio' END AS tipo,
       COALESCE(tf.nome, ep.nome)               AS conteudo,
       ts.nome                                  AS serie,
       u.temporada_numero,
       u.episodio_numero,
       u.ponto_parada_min,
       COALESCE(f.duracao_min, ep.duracao_min)  AS duracao_min
FROM ultima u
LEFT JOIN filme f    ON f.titulo_codigo = u.filme_codigo
LEFT JOIN titulo tf  ON tf.codigo = u.filme_codigo
LEFT JOIN episodio ep
       ON ep.serie_codigo = u.serie_codigo
      AND ep.temporada_numero = u.temporada_numero
      AND ep.numero = u.episodio_numero
LEFT JOIN titulo ts  ON ts.codigo = u.serie_codigo
WHERE u.ordem = 1;

COMMENT ON VIEW v_continuar_assistindo IS 'Última exibição de cada conteúdo por perfil, com o ponto de parada.';
