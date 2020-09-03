da_justica <- tibble::tribble(
  ~id_justica, ~descricao,
  "1", "Supremo Tribunal Federal",
  "2", "Conselho Nacional de Justiça",
  "3", "Superior Tribunal de Justiça",
  "4", "Justiça Federal",
  "5", "Justiça do Trabalho",
  "6", "Justiça Eleitoral",
  "7", "Justiça Militar da União",
  "8", "Justiça Estadual",
  "9", "Justiça Militar Estadual"
)

usethis::use_data(da_justica, overwrite = TRUE)
