SELECT t.nome AS titulo,
       a.nota,
       a.comentario
FROM avaliacao a
JOIN titulo t ON t.codigo = a.titulo_codigo
WHERE a.conta_email = %(email)s
  AND a.perfil_nome = %(perfil)s
ORDER BY a.nota DESC, t.nome;
