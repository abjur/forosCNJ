
# Foros CNJ

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

## Instalação

A versão de desenvolvimento de `{forosCNJ}` pode ser instalada a partir
do código:

``` r
devtools::install_github("abjur/forosCNJ")
```

## Exemplos

Segue abaixo alguns exemplos para o uso do pacote.

### Exemplo das Bases disponíveis

``` r
library(forosCNJ)
dplyr::glimpse(da_foro)
```

    ## Rows: 7,955
    ## Columns: 5
    ## $ id_justica  <chr> "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8…
    ## $ id_tribunal <chr> "26", "26", "26", "26", "26", "26", "26", "26", "26", "26…
    ## $ id_foro     <chr> "0000", "0001", "0002", "0003", "0004", "0005", "0006", "…
    ## $ comarca     <chr> "São Paulo", "São Paulo", "São Paulo", "São Paulo", "São …
    ## $ descricao   <chr> "Foro Unificado", "Foro Regional I - Santana", "Foro Regi…

### Exemplo de Tabela

``` r
da_foro_comarca %>% 
  dplyr::arrange(comarca) %>% 
  dplyr::filter(id_justica == 8) %>% 
  dplyr::sample_n(10) %>% 
  knitr::kable()
```

| id\_justica | id\_tribunal | id\_foro | comarca       | descricao                                                 | sigla | uf | ibge    |
| :---------- | :----------- | :------- | :------------ | :-------------------------------------------------------- | :---- | :- | :------ |
| 8           | 10           | 0100     | MIRINZAL      | Fórum da Comarca                                          | TJMA  | MA | 2106805 |
| 8           | 26           | 0236     | IBITINGA      | Foro de Ibitinga                                          | TJSP  | SP | 3519600 |
| 8           | 19           | 0071     | QUATIS        | Comarca de Porto Real - Quatis                            | TJRJ  | RJ | 3304128 |
| 8           | 24           | 0001     | FLORIANOPOLIS | 1ª Vara do Trabalho de Floriánopolis                      | TJSC  | SC | 4205407 |
| 8           | 10           | 0002     | SAO LUIS      | 1ª Vara da Infância e da Juventude                        | TJMA  | MA | 2111300 |
| 8           | 06           | 0025     | FORTALEZA     | Juizado da Violência Doméstica e Familiar Contra a Mulher | TJCE  | CE | 2304400 |
| 8           | 26           | 0028     | APARECIDA     | Foro de Aparecida                                         | TJSP  | SP | 3502507 |
| 8           | 24           | 0049     | FRAIBURGO     | Vara do Trabalho de Fraiburgo                             | TJSC  | SC | 4205506 |
| 8           | 13           | 0470     | PARACATU      | Paracatu                                                  | TJMG  | MG | 3147006 |
| 8           | 10           | 0061     | VIANA         | Fórum da Comarca                                          | TJMA  | MA | 2112803 |

### Exemplo de Gráfico

#### Gráfico de quantidade de Tribunais da Justiça federal por Siglas

``` r
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
```

![](README_files/figure-gfm/exampletagrafico-1.png)<!-- -->
