-- Pergunta: Quais séries têm mais episódios, e quanto tempo leva para ver tudo?
-- Recursos: JOIN com view (v_serie_temporadas), LEFT JOIN, GROUP BY, COUNT, SUM, ORDER BY
-- Parâmetros: nenhum

SELECT v.serie,
       v.total_temporadas,
       COUNT(e.numero)    AS total_episodios,
       SUM(e.duracao_min) AS duracao_total_min
FROM v_serie_temporadas v
LEFT JOIN episodio e ON e.serie_codigo = v.serie_codigo
GROUP BY v.serie_codigo, v.serie, v.total_temporadas
ORDER BY total_episodios DESC, duracao_total_min DESC, v.serie;
