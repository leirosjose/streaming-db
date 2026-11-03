-- Títulos para as listas de seleção. tipo nulo = todos.

SELECT codigo, nome, tipo
FROM titulo
WHERE %(tipo)s::text IS NULL OR tipo = %(tipo)s
ORDER BY nome;
