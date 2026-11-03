-- Pergunta: O que um perfil parou de ver no meio e em que minuto parou?
-- Recursos: view (v_continuar_assistindo, que usa CTE e ROW_NUMBER), WHERE com parâmetros, CASE
-- Parâmetros:
--   email  = 'ana.souza@email.com'
--   perfil = 'Lia'

SELECT CASE
           WHEN v.tipo = 'Filme' THEN v.conteudo
           ELSE v.serie || ' – T' || v.temporada_numero || 'E' || v.episodio_numero
                || ' – ' || v.conteudo
       END                              AS conteudo,
       v.data_hora                      AS ultima_exibicao,
       v.ponto_parada_min               AS parou_no_minuto,
       v.duracao_min,
       v.duracao_min - v.ponto_parada_min AS minutos_restantes
FROM v_continuar_assistindo v
WHERE v.conta_email = %(email)s
  AND v.perfil_nome = %(perfil)s
  AND v.ponto_parada_min < v.duracao_min   -- só o que não terminou
ORDER BY v.data_hora DESC;
