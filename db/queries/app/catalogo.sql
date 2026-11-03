-- Catálogo com média de avaliação (view v_titulo_avaliacao) e
-- filtros opcionais por tipo e gênero. Parâmetro nulo = sem filtro.

SELECT t.codigo,
       t.nome,
       CASE t.tipo WHEN 'F' THEN 'Filme' ELSE 'Série' END AS tipo,
       t.ano_lancamento,
       t.classificacao,
       (SELECT STRING_AGG(tg.genero_nome, ', ' ORDER BY tg.genero_nome)
          FROM titulo_genero tg
         WHERE tg.titulo_codigo = t.codigo) AS generos,
       va.media_nota,
       va.qtd_avaliacoes
FROM titulo t
JOIN v_titulo_avaliacao va ON va.codigo = t.codigo
WHERE (%(tipo)s::text IS NULL OR t.tipo = %(tipo)s)
  AND (%(genero)s::text IS NULL OR EXISTS (
        SELECT 1
        FROM titulo_genero tg
        WHERE tg.titulo_codigo = t.codigo
          AND tg.genero_nome = %(genero)s))
ORDER BY t.nome;
