library(tidyverse)

# arrumando nome das UFs

aux_ufs <- geobr::grid_state_correspondence_table %>%
  distinct(name_uf, code_state) %>%
  arrange(name_uf) %>%
  mutate(
    name_uf = case_when(
      name_uf == "Pernanbuco" ~ "Pernambuco",
      name_uf == "Distrito Federal" ~ "Distrito Federal e Territórios",
      TRUE ~ name_uf
    ),
    code_state = case_when(
      code_state == "DF" ~ "DFT",
      TRUE ~ code_state
    )
  )

eo <- case_when(
  aux_ufs$name_uf %in% c("Acre", "Amapá", "Amazonas", "Ceará",
                  "Distrito Federal e Territórios",
                  "Espírito Santo", "Maranhão", "Mato Grosso",
                  "Mato Grosso do Sul", "Pará", "Paraná", "Pernambuco",
                  "Piauí", "Rio de Janeiro", "Rio Grande do Norte",
                  "Rio Grande do Sul", "Tocantins") ~ "o",
  aux_ufs$name_uf %in% c("Bahia", "Paraíba") ~ "a",
  TRUE ~ "e"
)

aux_superiores <- tibble::tibble(
  id_justica = c("1", "2", "3", "4", "5", "5", "6", "7"),
  id_tribunal = c("00", "00", "00", "90", "00", "90", "00", "00"),
  descricao = c("Supremo Tribunal Federal", "Conselho Nacional de Justiça",
                "Superior Tribunal de Justiça", "Conselho da Justiça Federal",
                "Tribunal Superior do Trabalho",
                "Conselho Superior da Justiça do Trabalho",
                "Tribunal Superior Eleitoral",
                "Superior Tribunal Militar"),
  sigla = c("STF", "CNJ", "STJ", "CJF", "TST", "CSJT", "TSE", "STM")
)

aux_federal <- tibble::tibble(
  id_justica = "4",
  id_tribunal = sprintf("%02d", 1:5),
  descricao = str_glue("TRF da {1:5}ª Região"),
  sigla = str_glue("TRF{1:5}")
)

aux_trab <- tibble::tibble(
  id_justica = "5",
  id_tribunal = sprintf("%02d", 1:24),
  descricao = str_glue("TRT da {1:24}ª Região"),
  sigla = str_glue("TRT{sprintf('%02d', 1:24)}")
)

aux_eleitoral <- tibble::tibble(
  id_justica = "6",
  id_tribunal = sprintf("%02d", c(1:24, 26, 25, 27)),
  descricao = str_glue("Tribunal Regional Eleitoral d{eo} {aux_ufs$name_uf}"),
  sigla = str_glue("TRE{aux_ufs$code_state}"),
  uf = str_sub(aux_ufs$code_state, 1L, 2L)
)

aux_militar_uni <- tibble::tibble(
  id_justica = "7",
  id_tribunal = sprintf("%02d", 1:12),
  descricao = str_glue("{1:12}ª Circunscrição Judiciária Militar"),
  sigla = str_glue("CJM{sprintf('%02d', 1:12)}")
)

aux_estadual <- tibble::tibble(
  id_justica = "8",
  id_tribunal = sprintf("%02d", c(1:24, 26, 25, 27)),
  descricao = str_glue("Tribunal de Justiça d{eo} {aux_ufs$name_uf}"),
  sigla = str_glue("TJ{aux_ufs$code_state}"),
  uf = str_sub(aux_ufs$code_state, 1L, 2L)
)

aux_militar_est <- tibble::tibble(
  id_justica = "9",
  id_tribunal = c("13", "21", "26"),
  descricao = c("Tribunal de Justiça Militar do Estado de Minas Gerais",
                "Tribunal de Justiça Militar do Estado do Rio Grande do Sul",
                "Tribunal de Justiça Militar do Estado de São Paulo"),
  sigla = c("TJMMG", "TJMRS", "TJMSP"),
  uf = c("MG", "RS", "SP")
)

da_tribunal <- dplyr::bind_rows(
  aux_superiores,
  aux_federal,
  aux_trab,
  aux_eleitoral,
  aux_militar_uni,
  aux_estadual,
  aux_militar_est
)

usethis::use_data(da_tribunal, overwrite = TRUE)
