#' Classificacao de orgao ou segmento do poder judiciario.
#'
#' Um conjunto de dados que contem os orgaos e segmentos do poder
#' judiciario de 1:9.
#'
#' @format um data frame com 9 linhas and 2 variaveis:
#' \describe{
#' \item{id_justica}{numero de classificacao}
#' \item{descricao}{orgao ou segmento judiciario}
#' }
#'
#' @source \url{https://www.cnj.jus.br/programas-e-acoes/numeracao-unica/documentos/}
"da_justica"

#' Levantamento dos Tribunais.
#'
#' Um conjunto de dados que contem os Tribunais Federais, Estaduais,
#' e do Distrito Federal e Territórios, Tribuais Regional eleitoral
#'  e Tribunais Regionais do Trabalho.
#'
#' @format um data frame com 106 linhas and 5 variaveis:
#' \describe{
#'  \item{id_justica}{numero de classificacao}
#'  \item{id_tribunal}{classicacao pela da_justica}
#'  \item{descricao}{tribunal}
#'  \item{sigla}{sigla do respectivo tribunal}
#'  \item{uf}{estado do respectivo tribunal}
#' }
#'
#' @source \url{https://www.cnj.jus.br/programas-e-acoes/numeracao-unica/documentos/}
"da_tribunal"

#' Classficacao de foros e comarcas.
#'
#' Um conjunto de dados que contem todos os foros e comarcas
#' classificado pelo orgao e tribunal.
#'
#' @format um data frame com 7955 linhas and 5 variaveis:
#' \describe{
#'  \item{id_justica}{numero de classificacao}
#'  \item{id_tribunal}{classicacao pela da_justica}
#'  \item{id_foro}{numero do respectivo foro}
#'  \item{comarca}{comarca do respectivo foro}
#'  \item{descricao}{foro}
#' }
#'
#' @source \url{https://www.cnj.jus.br/programas-e-acoes/numeracao-unica/documentos/}
"da_foro"

#' Classficacao de foros, comarcas e o nº do IBGE.
#'
#' Um conjunto de dados que contem todos os foros e comarcas
#' classificado pelo orgao, tribunal e o nº do IBGE.
#'
#' @format um data frame com 7955 linhas and 8 variaveis:
#' \describe{
#'  \item{id_justica}{numero de classificacao}
#'  \item{id_tribunal}{classicacao pela da_justica}
#'  \item{id_foro}{numero id do respectivo foro}
#'  \item{comarca}{comarca do respectivo foro}
#'  \item{descricao}{foro}
#'  \item{sigla}{sigla do respectivo tribunal}
#'  \item{uf}{estado do respectivo foto}
#'  \item{ibge}{numero do ibge do respectivo foro}
#' }
#'
#' @source \url{https://www.cnj.jus.br/programas-e-acoes/numeracao-unica/documentos/}
"da_foro_comarca"

