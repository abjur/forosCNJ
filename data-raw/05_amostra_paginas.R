
library(tidyverse)

# montar lista de numeros -------------------------------------------------

aux_paths <- fs::dir_ls("/mnt/dados/abj/paginas", regexp = "paginas/(T|JF)[A-Z0-9]+$") %>%
  purrr::map(fs::dir_ls, regexp = "20(19|20)(-01)?(_novo)?_pages\\.rds") %>%
  purrr::map_chr(dplyr::last) %>%
  c(purrr::set_names("/mnt/dados/abj/paginas/JFMS/rds/201911.rds", ~dirname(dirname(.)))) %>%
  purrr::discard(is.na) %>%
  tibble::enframe() %>%
  dplyr::mutate(name = basename(name))

get_num_one <- function(path, tribunal) {
  message(path)
  path_save <- stringr::str_glue("data-raw/rds/paginas/{tribunal}.rds")
  if (!file.exists(path_save)) {
    aux_pags <- readr::read_rds(path)
    nums <- aux_pags %>%
      dplyr::transmute(processos = stringr::str_extract_all(txt, abjutils::pattern_cnj())) %>%
      dplyr::pull(processos) %>%
      unlist() %>%
      unique() %>%
      abjutils::clean_cnj() %>%
      stringr::str_pad(20, "left", "0") %>%
      unique()
    readr::write_rds(nums, path_save)
  }
}

with(aux_paths, purrr::walk2(value, name, get_num_one))

# join com base que ja existe ---------------------------------------------

devtools::load_all()

da_num <- fs::dir_ls("data-raw/rds/paginas") %>%
  map(read_rds) %>%
  enframe()

aux_join <- da_num %>%
  unnest(value) %>%
  filter(!is.na(value)) %>%
  mutate(
    id_justica = str_sub(value, 14L, 14L),
    id_tribunal = str_sub(value, 15L, 16L),
    id_foro = str_sub(value, 17L, 20L)
  ) %>%
  group_by(id_justica, id_tribunal, id_foro) %>%
  mutate(n = n()) %>%
  nest(data = c(name, value)) %>%
  ungroup() %>%
  arrange(desc(n))

aux_faltam <- aux_join %>%
  semi_join(da_tribunal, c("id_justica", "id_tribunal")) %>%
  anti_join(da_foro_comarca, c("id_justica", "id_tribunal", "id_foro"))

set.seed(1)
aux_faltam_numerosos <- aux_faltam %>%
  filter(n > 1000) %>%
  mutate(data = map(data, sample_n, 10)) %>%
  unnest(data) %>%
  select(id_justica, id_tribunal, id_foro, amostra = value, n) %>%
  arrange(id_justica, id_tribunal, id_foro)

set.seed(1)
aux_faltam_verificados <- aux_faltam %>%
  filter(n <= 1000) %>%
  unnest(data) %>%
  mutate(valido = abjutils::verify_cnj(value)) %>%
  filter(valido == "valido") %>%
  sample_frac(1) %>%
  group_by(id_justica, id_tribunal, id_foro) %>%
  slice(1:10) %>%
  ungroup() %>%
  select(id_justica, id_tribunal, id_foro, amostra = value, n)

aux_falta_classificar <- bind_rows(aux_faltam_numerosos, aux_faltam_verificados) %>%
  group_by(id_justica, id_tribunal, id_foro) %>%
  summarise(amostra = paste(amostra, collapse = ", "), n = sum(n), .groups = "drop") %>%
  arrange(desc(n), id_justica, id_tribunal, id_foro)

aux_faltam_classificar %>%
  semi_join(da_tribunal, c("id_justica", "id_tribunal"))

aux_faltam_classificar %>%
  count(id_justica) %>%
  print(n = 100)

write_rds(aux_falta_classificar, "data-raw/rds/aux_falta_classificar.rds")


aux_falta_classificar_format <- aux_falta_classificar %>%
  inner_join(da_justica, "id_justica") %>%
  rename(justica = descricao) %>%
  inner_join(da_tribunal, c("id_justica", "id_tribunal")) %>%
  rename(tribunal = descricao) %>%
  select(
    n, justica, tribunal, sigla, uf,
    id_justica, id_tribunal, id_foro, amostra
  ) %>%
  arrange(desc(n))
writexl::write_xlsx(aux_falta_classificar_format, "data-raw/xlsx/aux_falta_classificar_format.xlsx")

# levantamento TJSP -------------------------------------------------------

p <- aux_falta_classificar %>%
  filter(id_tribunal == "26", id_justica == "8") %>%
  mutate(amostra = str_split(amostra, ", ")) %>%
  unnest(amostra) %>%
  with(amostra)

# lex::tjsp_cpopg_download(p, "data-raw/html/", login = "27022971889", senha = "pesquisa")
# aux_cpopg <- lex::tjsp_cpopg_parse(fs::dir_ls("data-raw/html/"))

aux_verificados <- aux_cpopg %>%
  filter(!is.na(id_processo)) %>%
  transmute(
    area,
    id_processo = fs::path_file(fs::path_ext_remove(arq)),
    id_processo = str_extract(id_processo, "^[0-9]{20}"),
    distribuicao = coalesce(distribuicao, recebido_em),
    foro = str_extract(distribuicao, "Foro.*|[0-9]+ª RAJ.*")
  ) %>%
  mutate(id_foro = str_sub(id_processo, -4L, -1L)) %>%
  distinct(foro, id_foro, .keep_all = TRUE) %>%
  select(-distribuicao) %>%
  anti_join(filter(da_foro, id_tribunal == "26", id_justica == "8"), "id_foro") %>%
  arrange(id_foro)

writexl::write_xlsx(aux_verificados, "data-raw/xlsx/aux_verificados_tjsp.xlsx")


# aux_verificados %>%
#   group_by(id_foro) %>%
#   summarise(n_distintos = n_distinct(foro), .groups = "drop") %>%
#   arrange(desc(n_distintos))
#
# aux_verificados %>%
#   filter(area == "Cível") %>%
#   arrange(id_foro)
#
# aux_verificados %>%
#   distinct(id_foro)
#
# aux_verificados %>%
#   filter(id_foro == "0521")
#
#
# da_foro %>%
#   filter(id_tribunal == 26, id_justica == 8) %>%
#   View()
