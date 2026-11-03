# Minimundo: plataforma de streaming de vídeo

O sistema a ser modelado tem como objetivo gerenciar as operações de uma plataforma de streaming de vídeo sob demanda, controlando assinaturas, o catálogo de conteúdo, as pessoas envolvidas nas produções e as interações dos usuários com os vídeos.

## Assinaturas e contas

Para ter acesso à plataforma, cada cliente deve possuir uma conta exclusiva, identificada unicamente pelo seu e-mail cadastrado. No momento do cadastro, o sistema registra a senha de acesso, a data de criação da conta, um ou mais telefones de contato e o endereço completo de cobrança, composto por rua, número, cidade, estado e CEP.

Toda conta deve estar obrigatoriamente vinculada a exatamente um plano de assinatura vigente. A plataforma oferece planos pré-definidos (como Básico, Padrão e Premium), cada um identificado pelo seu nome, e o sistema precisa registrar o preço mensal, a qualidade máxima de vídeo e o limite de telas simultâneas de cada plano. Um mesmo plano pode estar vinculado a várias contas.

## Perfis

Como uma mesma conta pode ser usada por diferentes membros da família, o sistema permite a criação de 1 a 5 perfis de visualização dentro de uma única conta. O perfil não tem existência fora da conta à qual pertence e é identificado pelo seu nome, que é único dentro daquela conta. Para cada perfil, armazena-se a preferência de idioma e a indicação de se é um perfil infantil.

## Catálogo

O catálogo da plataforma é formado por diversos títulos. Todo título recebe um código único de identificação, nome, sinopse, ano de lançamento e classificação indicativa. Cada título pertence a um ou mais gêneros (ação, comédia, drama, etc.), e um gênero pode agrupar vários títulos.

Todo título deve ser obrigatoriamente de um, e somente um, de dois tipos: Filme ou Série.

- Se o título for um Filme, o sistema armazena a sua duração total em minutos.
- Se o título for uma Série, ela é dividida em temporadas numeradas, sendo o número da temporada único dentro da série. O sistema deve ser capaz de calcular o total de temporadas de cada série a partir das temporadas cadastradas. Cada temporada possui um conjunto de episódios numerados, sendo o número do episódio único dentro da temporada, e cada episódio possui nome e duração. Uma temporada só existe vinculada a uma série específica, assim como um episódio só existe vinculado à sua temporada.

## Elenco e produção

A plataforma mantém um cadastro de pessoas do meio audiovisual, com nome e data de nascimento. Uma pessoa pode participar de vários títulos, e um título conta com a participação de várias pessoas. Para cada participação, registra-se o papel exercido na produção (diretor, roteirista ou ator), sendo possível que uma mesma pessoa exerça mais de um papel no mesmo título. Quando o papel for de ator ou atriz, registra-se também o nome do personagem interpretado.

## Exibições e avaliações

O sistema registra o consumo de conteúdo de cada perfil. Cada vez que um perfil inicia a exibição de um filme ou de um episódio de série, o sistema registra uma exibição contendo a data, a hora de início e o ponto de parada (em minutos), permitindo que o usuário retome o conteúdo de onde parou. Um perfil pode ter várias exibições, inclusive do mesmo conteúdo, e cada exibição pertence a um único perfil e se refere a um único filme ou episódio.

Além disso, cada perfil pode avaliar um título, registrando uma nota de 1 a 5 estrelas e um comentário opcional. É permitida apenas uma avaliação por perfil para cada título, e um título pode receber avaliações de vários perfis.
