-- Filme: preencher filme. Episódio: preencher serie, temporada e episodio.
-- Os demais ficam nulos.

INSERT INTO exibicao (conta_email, perfil_nome, data_hora, ponto_parada_min,
                      filme_codigo, serie_codigo, temporada_numero, episodio_numero)
VALUES (%(email)s, %(perfil)s, %(data_hora)s, %(ponto_parada)s,
        %(filme)s, %(serie)s, %(temporada)s, %(episodio)s);
