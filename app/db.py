import os
import re
from pathlib import Path

import pandas as pd
import psycopg
from dotenv import load_dotenv

RAIZ = Path(__file__).resolve().parent.parent
PASTA_CONSULTAS = RAIZ / "db" / "queries"

load_dotenv(RAIZ / ".env")


def conectar():
    return psycopg.connect(
        host=os.getenv("POSTGRES_HOST", "localhost"),
        port=os.getenv("POSTGRES_PORT", "5432"),
        dbname=os.getenv("POSTGRES_DB", "streaming"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
    )


# nome sem a extensão, ex: "01_titulos_mais_bem_avaliados" ou "app/catalogo"
def carregar_sql(nome):
    return (PASTA_CONSULTAS / f"{nome}.sql").read_text(encoding="utf-8")


# Lê as consultas numeradas e tira do cabeçalho a pergunta e os valores de
# exemplo (linhas "--   nome = valor"), que a página Consultas usa como padrão.
def listar_consultas():
    consultas = []
    for arquivo in sorted(PASTA_CONSULTAS.glob("[0-9]*.sql")):
        sql = arquivo.read_text(encoding="utf-8")
        pergunta = re.search(r"^--\s*Pergunta:\s*(.+)$", sql, re.M)
        exemplos = dict(re.findall(r"^--\s+(\w+)\s*=\s*(.+?)\s*$", sql, re.M))
        consultas.append({
            "nome": arquivo.stem,
            "pergunta": pergunta.group(1) if pergunta else arquivo.stem,
            "sql": sql,
            # dict.fromkeys tira os repetidos mantendo a ordem
            "parametros": list(dict.fromkeys(re.findall(r"%\((\w+)\)s", sql))),
            "exemplos": {k: v.strip("'") for k, v in exemplos.items()},
        })
    return consultas


def consultar(nome, params=None):
    with conectar() as conn, conn.cursor() as cur:
        cur.execute(carregar_sql(nome), params)
        colunas = [c.name for c in cur.description]
        return pd.DataFrame(cur.fetchall(), columns=colunas)


# o with faz o commit no final se não der erro
def executar(nome, params):
    with conectar() as conn:
        conn.execute(carregar_sql(nome), params)


# constraints que dá pra violar pelos formulários do app
EXPLICACAO_CONSTRAINT = {
    "avaliacao_pkey": "Este perfil já avaliou este título. Cada perfil avalia um título no máximo uma vez.",
    "avaliacao_nota_check": "A nota precisa estar entre 1 e 5.",
    "avaliacao_perfil_fkey": "O perfil informado não existe.",
    "exibicao_pkey": "Este perfil já tem uma exibição registrada nessa mesma data e hora.",
    "exibicao_conteudo_check": "A exibição precisa se referir a exatamente um filme ou um episódio.",
    "exibicao_episodio_fkey": "O episódio informado não existe.",
    "exibicao_ponto_parada_check": "O ponto de parada não pode ser negativo.",
}

TIPO_ERRO = {
    "23505": "Violação de chave primária ou de unicidade",
    "23503": "Violação de chave estrangeira",
    "23514": "Violação de restrição CHECK",
    "23502": "Valor obrigatório não informado (NOT NULL)",
}


def descrever_erro(erro):
    diag = erro.diag
    linhas = [TIPO_ERRO.get(erro.sqlstate, "Erro do banco") + f" (SQLSTATE {erro.sqlstate})"]
    if diag.constraint_name:
        linhas.append(f"Constraint: {diag.constraint_name}")
        if diag.constraint_name in EXPLICACAO_CONSTRAINT:
            linhas.append(EXPLICACAO_CONSTRAINT[diag.constraint_name])
    linhas.append(f"Mensagem do PostgreSQL: {diag.message_primary}")
    if diag.message_detail:
        linhas.append(f"Detalhe: {diag.message_detail}")
    return "\n\n".join(linhas)
