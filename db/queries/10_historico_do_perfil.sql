-- Pergunta: Quais foram todas as exibições de um perfil, em ordem cronológica?
-- Recursos: LEFT JOIN em várias tabelas, CASE, concatenação de texto, COALESCE, WHERE com parâmetros
-- Parâmetros:
--   email  = 'carlos.lima@email.com'
--   perfil = 'Carlos'

SELECT e.data_hora,
       CASE
           WHEN e.filme_codigo IS NOT NULL THEN tf.nome
           ELSE ts.nome || ' – T' || e.temporada_numero || 'E' || e.episodio_numero
                || ' – ' || ep.nome
       END                                    AS conteudo,
       e.ponto_parada_min,
       COALESCE(f.duracao_min, ep.duracao_min) AS duracao_min
FROM exibicao e
LEFT JOIN filme f   ON f.titulo_codigo = e.filme_codigo
LEFT JOIN titulo tf ON tf.codigo = e.filme_codigo
LEFT JOIN episodio ep
       ON ep.serie_codigo = e.serie_codigo
      AND ep.temporada_numero = e.temporada_numero
      AND ep.numero = e.episodio_numero
LEFT JOIN titulo ts ON ts.codigo = e.serie_codigo
WHERE e.conta_email = %(email)s
  AND e.perfil_nome = %(perfil)s
ORDER BY e.data_hora;
