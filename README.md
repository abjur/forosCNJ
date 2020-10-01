
# Foros CNJ

O objetivo do `{forosCNJ}` é disponibilizar bases de dados e
documentação do projeto de levantamento das comarcas e códigos do
Brasil, considerando o disposto na [Resolução Nº 65/2008 do
CNJ](https://atos.cnj.jus.br/atos/detalhar/119), que trata da
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

| id\_justica | id\_tribunal | id\_foro | comarca                | descricao                         | sigla | uf | ibge    |
| :---------- | :----------- | :------- | :--------------------- | :-------------------------------- | :---- | :- | :------ |
| 8           | 05           | 0154     | LUIS EDUARDO MAGALHAES | Comarca de Luis Eduardo Magalhães | TJBA  | BA | 2919553 |
| 8           | 17           | 0140     | AGUA PRETA             | Agua Preta                        | TJPE  | PE | 2600401 |
| 8           | 10           | 0114     | RIACHAO                | Fórum da Comarca                  | TJMA  | MA | 2109502 |
| 8           | 13           | 0183     | CONSELHEIRO LAFAIETE   | Conselheiro Lafaiete              | TJMG  | MG | 3118304 |
| 8           | 26           | 0146     | CORDEIROPOLIS          | Foro de Cordeirópolis             | TJSP  | SP | 3512407 |
| 8           | 15           | 0831     | CACIMBA DE DENTRO      | Dentro                            | TJPB  | PB | 2503506 |
| 8           | 14           | 0136     | CANAA DOS CARAJAS      | Canaa dos Carajas                 | TJPA  | PA | 1502152 |
| 8           | 13           | 0248     | ESTRELA DO SUL         | Estrela do Sul                    | TJMG  | MG | 3124807 |
| 8           | 14           | 0003     | ALENQUER               | Alenquer                          | TJPA  | PA | 1500404 |
| 8           | 13           | 0116     | CAMPOS GERAIS          | Campos Gerais                     | TJMG  | MG | 3111606 |

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
