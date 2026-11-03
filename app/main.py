import datetime as dt

import psycopg
import streamlit as st

import db

st.set_page_config(page_title="Plataforma de Streaming", layout="wide")


def mostrar_tabela(df, vazio="Nenhuma linha retornada."):
    if df.empty:
        st.info(vazio)
    else:
        st.dataframe(df, hide_index=True)
        st.caption(f"{len(df)} linha(s)")


# usado em Meu perfil e Avaliar; a chave evita conflito entre os widgets das duas
def escolher_perfil(chave):
    contas = db.consultar("app/contas")
    email = st.selectbox("Conta", contas["email"].tolist(), key=f"{chave}_conta")
    perfis = db.consultar("app/perfis_da_conta", {"email": email})
    perfil = st.selectbox("Perfil", perfis["nome"].tolist(), key=f"{chave}_perfil")
    return email, perfil


def pagina_catalogo():
    st.title("Catálogo")
    col1, col2 = st.columns(2)
    tipo = col1.selectbox("Tipo", ["Todos", "Filme", "Série"])
    generos = db.consultar("app/generos")["nome"].tolist()
    genero = col2.selectbox("Gênero", ["Todos"] + generos)

    params = {
        "tipo": {"Todos": None, "Filme": "F", "Série": "S"}[tipo],
        "genero": None if genero == "Todos" else genero,
    }
    catalogo = db.consultar("app/catalogo", params)
    # sem avaliação a média vem NULL, e o dataframe mostraria "None"
    catalogo["media_nota"] = catalogo["media_nota"].map(lambda v: "" if v is None else f"{v:.2f}")
    mostrar_tabela(catalogo, "Nenhum título com esses filtros.")


def pagina_consultas():
    st.title("Consultas")
    consultas = {c["nome"]: c for c in db.listar_consultas()}
    nome = st.selectbox(
        "Consulta",
        list(consultas),
        format_func=lambda n: f"{n[:2]}. {consultas[n]['pergunta']}",
    )
    consulta = consultas[nome]
    st.caption(f"Arquivo: db/queries/{nome}.sql")

    params = {}
    for p in consulta["parametros"]:
        exemplo = consulta["exemplos"].get(p, "")
        chave = f"{nome}_{p}"
        if exemplo.isdigit():
            params[p] = int(st.number_input(p, value=int(exemplo), step=1, key=chave))
        else:
            params[p] = st.text_input(p, value=exemplo, key=chave)

    if st.button("Executar"):
        try:
            mostrar_tabela(db.consultar(nome, params or None))
        except psycopg.Error as erro:
            st.error(db.descrever_erro(erro))

    st.subheader("SQL")
    st.code(consulta["sql"], language="sql")


def pagina_meu_perfil():
    st.title("Meu perfil")
    email, perfil = escolher_perfil("meu_perfil")
    params = {"email": email, "perfil": perfil}

    st.subheader("Continuar assistindo")
    mostrar_tabela(db.consultar("02_continuar_assistindo", params), "Nenhum conteúdo pela metade.")

    st.subheader("Avaliações")
    mostrar_tabela(db.consultar("app/avaliacoes_do_perfil", params), "Este perfil ainda não avaliou nenhum título.")


def pagina_avaliar():
    st.title("Avaliar")
    email, perfil = escolher_perfil("avaliar")

    st.subheader("Nova avaliação")
    titulos = db.consultar("app/titulos", {"tipo": None})
    tipos = {"F": "Filme", "S": "Série"}
    nomes = {
        codigo: f"{nome} ({tipos[tipo]})"
        for codigo, nome, tipo in zip(titulos["codigo"].tolist(), titulos["nome"], titulos["tipo"])
    }
    with st.form("form_avaliacao"):
        titulo = st.selectbox("Título", list(nomes), format_func=nomes.get)
        nota = st.slider("Nota", 1, 5, 5)
        comentario = st.text_area("Comentário (opcional)")
        if st.form_submit_button("Salvar avaliação"):
            try:
                db.executar("app/inserir_avaliacao", {
                    "email": email,
                    "perfil": perfil,
                    "titulo": titulo,
                    "nota": nota,
                    "comentario": comentario.strip() or None,
                })
                st.success("Avaliação registrada.")
            except psycopg.Error as erro:
                st.error(db.descrever_erro(erro))

    st.subheader("Registrar exibição")
    tipo = st.radio("Conteúdo", ["Filme", "Episódio"], horizontal=True)
    if tipo == "Filme":
        filmes = db.consultar("app/titulos", {"tipo": "F"})
        nomes = dict(zip(filmes["codigo"].tolist(), filmes["nome"]))
        filme = st.selectbox("Filme", list(nomes), format_func=nomes.get)
        conteudo = {"filme": filme, "serie": None, "temporada": None, "episodio": None}
    else:
        series = db.consultar("app/titulos", {"tipo": "S"})
        nomes = dict(zip(series["codigo"].tolist(), series["nome"]))
        serie = st.selectbox("Série", list(nomes), format_func=nomes.get)
        episodios = db.consultar("app/episodios_da_serie", {"serie": serie})
        opcoes = list(zip(episodios["temporada_numero"].tolist(),
                          episodios["numero"].tolist(),
                          episodios["nome"]))
        temporada, episodio, _ = st.selectbox(
            "Episódio", opcoes, format_func=lambda o: f"T{o[0]}E{o[1]} – {o[2]}")
        conteudo = {"filme": None, "serie": serie, "temporada": temporada, "episodio": episodio}

    agora = dt.datetime.now().replace(second=0, microsecond=0)
    col1, col2, col3 = st.columns(3)
    data = col1.date_input("Data", agora.date())
    hora = col2.time_input("Hora", agora.time())
    ponto = col3.number_input("Ponto de parada (min)", min_value=0, value=0, step=1)

    if st.button("Registrar exibição"):
        try:
            db.executar("app/inserir_exibicao", {
                "email": email,
                "perfil": perfil,
                "data_hora": dt.datetime.combine(data, hora),
                "ponto_parada": int(ponto),
                **conteudo,
            })
            st.success("Exibição registrada.")
        except psycopg.Error as erro:
            st.error(db.descrever_erro(erro))


pagina = st.sidebar.radio("Página", ["Catálogo", "Consultas", "Meu perfil", "Avaliar"])
if pagina == "Catálogo":
    pagina_catalogo()
elif pagina == "Consultas":
    pagina_consultas()
elif pagina == "Meu perfil":
    pagina_meu_perfil()
else:
    pagina_avaliar()
