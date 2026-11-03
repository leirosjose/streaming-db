SELECT nome, idioma, infantil
FROM perfil
WHERE conta_email = %(email)s
ORDER BY nome;
