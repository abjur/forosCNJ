
Foros CNJ
=========

O objetivo do `{forosCNJ}` é disponibilizar bases de dados e
documentação do projeto de levantamento das comarcas e códigos do
Brasil, considerando o disposto na [Resolução Nº 65/2008 do
CNJ](https://atos.cnj.jus.br/atos/detalhar/119), que trada da
uniformização do número dos processos nos órgãos do Poder Judiciário e
dá outras providências, favorecendo a consulta processual.

O número CNJ possui a estrutura NNNNNNN-DD.AAAA.J.TR.OOOO, composto por
seis campos obrigatórios.

Os dados foram coletados através dos anexos do [Conselho Nacional de
Justiça](https://www.cnj.jus.br/programas-e-acoes/numeracao-unica/documentos/).
Inclui-se Supremo Tribunal Federal, Conselho Nacional de Justiça,
Superior Tribunal de Justiça, Justiça Federal, Justiça do Trabalho,
Justiça Eleitoral, Justiça Militar da União, Justiça Estadual, Justiça
Militar Estadual.

Instalação
----------

A versão de desenvolvimento de `{forosCNJ}` pode ser instalada a partir
do código:

    devtools::install_github("abjur/forosCNJ")

Exemplos
--------

Segue abaixo alguns exemplos para o uso do pacote.

### Exemplo das Bases disponíveis

    library(forosCNJ)
    dplyr::glimpse(da_foro)

    ## Rows: 7,955
    ## Columns: 5
    ## $ id_justica  <chr> "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8…
    ## $ id_tribunal <chr> "26", "26", "26", "26", "26", "26", "26", "26", "26", "26…
    ## $ id_foro     <chr> "0000", "0001", "0002", "0003", "0004", "0005", "0006", "…
    ## $ comarca     <chr> "São Paulo", "São Paulo", "São Paulo", "São Paulo", "São …
    ## $ descricao   <chr> "Foro Unificado", "Foro Regional I - Santana", "Foro Regi…

### Exemplo de Tabela

    da_foro_comarca %>% 
      dplyr::arrange(comarca) %>% 
      dplyr::filter(id_justica == 8) %>% 
      dplyr::sample_n(10) %>% 
      knitr::kable()

| id\_justica | id\_tribunal | id\_foro | comarca                  | descricao                    | sigla | uf  | ibge    |
|:------------|:-------------|:---------|:-------------------------|:-----------------------------|:------|:----|:--------|
| 8           | 06           | 0115     | LIMOEIRO DO NORTE        | Comarca de Limoeiro do Norte | TJCE  | CE  | 2307601 |
| 8           | 13           | 0408     | MATIAS BARBOSA           | Matias Barbosa               | TJMG  | MG  | 3140803 |
| 8           | 14           | 0133     | MARITUBA                 | Marituba                     | TJPA  | PA  | 1504422 |
| 8           | 09           | 0165     | CIDADE OCIDENTAL         | FORUM DOS JUIZADOS           | TJGO  | GO  | 5205497 |
| 8           | 10           | 0104     | PARAIBANO                | Fórum da Comarca             | TJMA  | MA  | 2107704 |
| 8           | 26           | 0219     | MOGI DAS CRUZES          | Foro Distrital de Guararema  | TJSP  | SP  | 3530607 |
| 8           | 13           | 0624     | SAO JOAO DA PONTE        | São João da Ponte            | TJMG  | MG  | 3162401 |
| 8           | 26           | 0531     | SANTA ADELIA             | Foro de Santa Adélia         | TJSP  | SP  | 3545605 |
| 8           | 13           | 0647     | SAO SEBASTIAO DO PARAISO | São Sebastião do Paraiso     | TJMG  | MG  | 3164704 |
| 8           | 26           | 0710     | SAO PAULO                | Foro Distrital de Perus      | TJSP  | SP  | 3550308 |

### Exemplo de Gráfico

#### Gráfico de quantidade de Tribunais da Justiça federal por Siglas

    library(ggplot2)

    da_foro_comarca %>%
      dplyr::filter(id_justica == 4) %>% 
      ggplot() +
      geom_bar(aes(x = sigla), fill = viridis::viridis(1, 1, .2, .8)) +
      theme_minimal(14) +
      labs(
        x = "Tribunal Regional Federal", 
        y = "Quantidade de códigos de foro"
      )

![](README_files/figure-gfm/exampletagrafico-1.png)<!-- -->

l
