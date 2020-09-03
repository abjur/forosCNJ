library(tidyverse)
devtools::load_all()

# import ------------------------------------------------------------------

googledrive::drive_auth("jtrecenti@abjur.org.br")
googlesheets4::gs4_auth("jtrecenti@abjur.org.br")
id <- googledrive::as_id("1YZFGxh7c4Y0w6VAnyUAC1tHU9cFWSR-I1Vetbrg0cLE")
tabelas <- googlesheets4::sheet_names(id)
da_foros_raw <- purrr::map_dfr(tabelas, ~googlesheets4::read_sheet(id, .x)) %>%
  # duplicado ou invalido
  filter(tribunal != "TRE", !comarca %in% "EXTERIOR")

arruma_eleitoral <- function(x) {
  geo <- geobr::grid_state_correspondence_table %>%
    dplyr::distinct(name_uf, code_state) %>%
    dplyr::arrange(name_uf) %>%
    dplyr::mutate(value = toupper(name_uf)) %>%
    dplyr::mutate(value = dplyr::if_else(value == "PERNANBUCO", "PERNAMBUCO", value))
  x %>%
    tibble::enframe() %>%
    dplyr::left_join(geo, "value") %>%
    dplyr::mutate(
      code = paste0("TRE", code_state),
      code = dplyr::if_else(code == "TREDF", "TREDFT", code)
    ) %>%
    dplyr::pull(code)
}

# tidy -----------------------------------------------------------------------

aux_foro_justica <- da_foros_raw %>%
  mutate(justica = case_when(
    justica == "Eleitorais" | tribunal == "TRE" ~ "Justiça Eleitoral",
    justica == "Militar" ~ "Justiça Militar Estadual",
    justica == "Trabalhista" ~ "Justiça do Trabalho",
    justica == "Superior" ~ "Justiça Militar da União",
    TRUE ~ paste("Justiça", justica)
  )) %>%
  inner_join(da_justica, c("justica" = "descricao"))

aux_foro_justica_tribunal <- aux_foro_justica %>%
  mutate(tribunal_arrumado = case_when(
    tribunal == "TRF" & comarca %in% c("São Paulo", "Mato Grosso do Sul") ~ "TRF3",
    tribunal == "TRF" & comarca %in% c("Rio Grande do Sul", "Paraná", "Santa Catarina") ~ "TRF4",
    tribunal == "TRF" & comarca %in% c("Rio de Janeiro", "Espírito Santo") ~ "TRF2",
    tribunal == "TRF" & comarca %in% c("Alagoas", "Ceará", "Paraíba", "Pernambuco",
                                       "Rio Grande do Norte", "Sergipe") ~ "TRF5",
    tribunal == "TRF" ~ "TRF1",
    tribunal == "ZONA ELEITORAIS" ~ arruma_eleitoral(comarca),
    tribunal == "TRE-BH" ~ "TREBA",
    tribunal == "STM" ~ sprintf("CJM%02d", as.numeric(str_extract(nome, "[0-9]{1,2}(?=ª CJM)"))),
    str_detect(tribunal, "TRT") ~ paste0("TRT", sprintf("%02d", as.numeric(str_extract(tribunal, "[0-9]{1,2}")))),
    TRUE ~ tribunal
  )) %>%
  inner_join(da_tribunal, c("id_justica", c("tribunal_arrumado" = "sigla")))

da_foro <- aux_foro_justica_tribunal %>%
  select(id_justica, id_tribunal, id_foro = codigo, comarca, descricao = nome)

usethis::use_data(da_foro, overwrite = TRUE)




