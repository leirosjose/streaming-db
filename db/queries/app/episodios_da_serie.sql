SELECT temporada_numero, numero, nome, duracao_min
FROM episodio
WHERE serie_codigo = %(serie)s
ORDER BY temporada_numero, numero;
