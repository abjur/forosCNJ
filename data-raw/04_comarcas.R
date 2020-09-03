library(tidyverse)
devtools::load_all()

geo_muni <- geobr::read_municipality(year = 2019)

clean_txt <- function(x) {
  x %>%
    toupper() %>%
    abjutils::rm_accent() %>%
    stringr::str_remove_all("'") %>%
    stringr::str_replace_all("-", " ") %>%
    stringr::str_squish() %>%
    stringr::str_remove("COMARCA DE|([0-9]ª )?TURMA RECURSAL DE|CAPITAL JUIZO D[EA] ") %>%
    stringr::str_squish()
}

aux_muni <- geo_muni %>%
  as.data.frame() %>%
  select(ibge = code_muni, muni = name_muni, uf = abbrev_state) %>%
  mutate(across(.fns = clean_txt)) %>%
  as_tibble() %>%
  mutate(id_justica = "8")

da_foro_comarca <- da_foro %>%
  mutate(comarca = clean_txt(comarca)) %>%
  inner_join(select(da_tribunal, -descricao), c("id_justica", "id_tribunal")) %>%
  mutate(
    comarca = str_replace(comarca, "DO OESTE", "DOESTE"),
    comarca = str_replace(comarca, fixed("N. SRA. "), "NOSSA SENHORA "),
    comarca = str_replace(comarca, fixed("STA."), "SANTA"),
  ) %>%
  mutate(comarca = case_when(
    uf == "DF" ~ "BRASILIA",
    uf == "SP" & comarca == "EMBU" ~ "EMBU DAS ARTES",
    uf == "SP" & comarca == "IPAUCU" ~ "IPAUSSU",
    uf == "AC" & comarca == "MANUEL URBANO" ~ "MANOEL URBANO",
    uf == "AC" & comarca == "SANTA ROSA" ~ "SANTA ROSA DO PURUS",
    uf == "AL" & comarca == "SANTANA DE IPANEMA" ~ "SANTANA DO IPANEMA",
    uf == "AL" & comarca == "SAO LUIZ DO QUITUNDE" ~ "SAO LUIS DO QUITUNDE",
    uf == "BA" & comarca == "GOVERNADOR LOMANTO JUNIOR" ~ "BARRO PRETO",
    uf == "CE" & comarca == "CHORO LIMAO" ~ "CHORO",
    uf == "PA" & comarca == "ICOARACI" ~ "BELEM",
    uf == "PE" & comarca == "SAOLA" ~ "SALOA",
    uf == "RJ" & comarca == "CARAGOALO" ~ "CANTAGALO",
    uf == "RJ" & comarca == "INHOMIRIM" ~ "MAGE",
    uf == "RN" & comarca == "PERNAMINIM" ~ "PARNAMIRIM",
    uf == "CE" & comarca == "AIUBA" ~ "GUAIUBA",
    uf == "AL" & comarca == "SAO JOSE DA LAGE" ~ "SAO JOSE DA LAJE",
    uf == "AL" & comarca == "CAMARAGIBE" ~ "MATRIZ DE CAMARAGIBE",
    uf == "AL" & comarca == "COLONIA DE LEOPOLDINA" ~ "COLONIA LEOPOLDINA",
    uf == "AL" & comarca == "MAJOR IZIDORO" ~ "MAJOR ISIDORO",
    uf == "AL" & comarca == "PORTO DAS PEDRAS" ~ "PORTO DE PEDRAS",
    uf == "AL" & comarca == "MATRIZ DO CAMARAGIBE" ~ "MATRIZ DE CAMARAGIBE",
    uf == "AL" & comarca == "FLEIXEIRAS" ~ "FLEXEIRAS",
    uf == "AM" & comarca == "BOA VISTA DOS RAMOS" ~ "BOA VISTA DO RAMOS",
    uf == "AM" & comarca == "ELRUNEPE" ~ "EIRUNEPE",
    uf == "AM" & comarca == "HUMALTA" ~ "HUMAITA",
    uf == "AM" & comarca == "PAULNI" ~ "PAUINI",
    uf == "BA" & comarca == "CAMACA" ~ "CAMACAN",
    uf == "CE" & comarca == "MORAVA NOVA" ~ "MORADA NOVA",
    uf == "ES" & comarca == "CACHOEIRO DO ITAPEMIRIM" ~ "CACHOEIRO DE ITAPEMIRIM",
    uf == "GO" & comarca == "BOM JESUS" ~ "BOM JESUS DE GOIAS",
    uf == "MG" & comarca == "CADEIAS" ~ "CANDEIAS",
    uf == "MA" & comarca == "SAO JOSE DO RIBAMAR" ~ "SAO JOSE DE RIBAMAR",
    uf == "MA" & comarca == "CEDRAI" ~ "CEDRAL",
    uf == "MA" & comarca == "CURUPURU" ~ "CURURUPU",
    uf == "MA" & comarca == "ESPERANTIOPOLIS" ~ "ESPERANTINOPOLIS",
    uf == "MA" & comarca == "OLHO DAGUA DA CUNHAS" ~ "OLHO DAGUA DAS CUNHAS",
    uf == "MA" & comarca == "POCAO DAS PEDRAS" ~ "POCAO DE PEDRAS",
    uf == "MA" & comarca == "SAO MATEUS" ~ "SAO MATEUS DO MARANHAO",
    uf == "MA" & comarca == "SENADOR LA ROQUE" ~ "SENADOR LA ROCQUE",
    uf == "MG" & comarca == "ABATE" ~ "ABAETE",
    uf == "MG" & comarca == "ARACUI" ~ "ARACUAI",
    uf == "MG" & comarca == "BARABACENA" ~ "BARBACENA",
    uf == "MG" & comarca == "CAMANDUCAI" ~ "CAMANDUCAIA",
    uf == "MG" & comarca == "CTAGUASES" ~ "CATAGUASES",
    uf == "MG" & comarca == "ESPIOSA" ~ "ESPINOSA",
    uf == "MG" & comarca == "FORMINGA" ~ "FORMIGA",
    uf == "MG" & comarca == "GRAO MONGOL" ~ "GRAO MOGOL",
    uf == "MG" & comarca == "ITAMOJI" ~ "ITAMOGI",
    uf == "MG" & comarca == "ITAPAJIPE" ~ "ITAPAGIPE",
    uf == "MG" & comarca == "JABUTICATUBAS" ~ "JABOTICATUBAS",
    uf == "MG" & comarca == "JEQUINHATINHO" ~ "JEQUITINHONHA",
    uf == "MG" & comarca == "MONTE CARLOS" ~ "MONTES CLAROS",
    uf == "MG" & comarca == "MORADA NOVAS DE MINAS" ~ "MORADA NOVA DE MINAS",
    uf == "MG" & comarca == "PORTEIRINA" ~ "PORTEIRINHA",
    uf == "MG" & comarca == "PRESISDENTE OLEGARIO" ~ "PRESIDENTE OLEGARIO",
    uf == "MG" & comarca == "SANTA LUIZA" ~ "SANTA LUZIA",
    uf == "MG" & comarca == "SANTA MARIA DO SUACI" ~ "SANTA MARIA DO SUACUI",
    uf == "MG" & comarca == "SAO GONCALDO DO PRATA" ~ "SAO GONCALO DO PARA",
    uf == "MS" & comarca == "APARECIDO DO TABOADO" ~ "APARECIDA DO TABOADO",
    uf == "MS" & comarca == "SAO GABRIEL DOESTE" ~ "SAO GABRIEL DO OESTE",
    uf == "MT" & comarca == "RONDOPOLIS" ~ "RONDONOPOLIS",
    uf == "MT" & comarca == "CARCERES" ~ "CACERES",
    uf == "MT" & comarca == "NOVA OLIMIPIA" ~ "NOVA OLIMPIA",
    uf == "PA" & comarca == "AUROPA DO PARA" ~ "AURORA DO PARA",
    uf == "PA" & comarca == "CACHOEIRRA DO ARARI" ~ "CACHOEIRA DO ARARI",
    uf == "PA" & comarca == "DOM ELIZEU" ~ "DOM ELISEU",
    uf == "PA" & comarca == "INHAGAPI" ~ "INHANGAPI",
    uf == "PA" & comarca == "MEDICILLANDIA" ~ "MEDICILANDIA",
    uf == "PA" & comarca == "MELGADO" ~ "MELGACO",
    uf == "PA" & comarca == "PONTA DAS PEDRAS" ~ "PONTA DE PEDRAS",
    uf == "PA" & comarca == "SANTA ISABEL" ~ "SANTA IZABEL DO PARA",
    uf == "PA" & comarca == "SANTA LUIZIA DO PARA" ~ "SANTA LUZIA DO PARA",
    uf == "PA" & comarca == "SANATAREM NOVO" ~ "SANTAREM NOVO",
    uf == "PA" & comarca == "SAO DOMNGOS DO CAPIM" ~ "SAO DOMINGOS DO CAPIM",
    uf == "PB" & comarca == "E BREJO DO CRUZ" ~ "BREJO DO CRUZ",
    uf == "PB" & comarca == "SAO JOAO DO CARIR" ~ "SAO JOAO DO CARIRI",
    uf == "PB" & comarca == "DENTRO" ~ "CACIMBA DE DENTRO",
    uf == "PE" & comarca == "ALOGOINHA" ~ "ALAGOINHA",
    uf == "PE" & comarca == "BELEM DO SAO FANCISCO" ~ "BELEM DO SAO FRANCISCO",
    uf == "PE" & comarca == "GARANHUS" ~ "GARANHUNS",
    uf == "PE" & comarca == "ITAMARACA" ~ "ILHA DE ITAMARACA",
    uf == "PE" & comarca == "LAGOA DO ITAENGA" ~ "LAGOA DE ITAENGA",
    uf == "PE" & comarca == "PALMEIRINHA" ~ "PALMEIRINA",
    uf == "PE" & comarca == "SAO CAETANO" ~ "SAO CAITANO",
    uf == "PE" & comarca == "SAO JOAO DO BELMONTE" ~ "SAO JOSE DO BELMONTE",
    uf == "PI" & comarca == "AVALINO LOPES" ~ "AVELINO LOPES",
    uf == "PI" & comarca == "BENEDITOS" ~ "BENEDITINOS",
    uf == "PI" & comarca == "CRISTIANO CASTRO" ~ "CRISTINO CASTRO",
    uf == "PI" & comarca == "LUIZ CORREIA" ~ "LUIS CORREIA",
    uf == "PI" & comarca == "PALMEIRAS" ~ "PALMEIRAIS",
    uf == "PI" & comarca == "VALENCA" ~ "VALENCA DO PIAUI",
    uf == "PI" & comarca == "ARRAIAL DO PIAUI" ~ "ARRAIAL",
    uf == "PI" & comarca == "BERTOLANDIA" ~ "BERTOLINIA",
    uf == "PI" & comarca == "CAPITAO DOS CAMPOS" ~ "CAPITAO DE CAMPOS",
    uf == "PI" & comarca == "ELIZEU MARTINS" ~ "ELISEU MARTINS",
    uf == "PI" & comarca == "FRANCINIPOLIS" ~ "FRANCINOPOLIS",
    uf == "PI" & comarca == "SAO GOLCALO DO PIAUI" ~ "SAO GONCALO DO PIAUI",
    uf == "PR" & comarca == "ASSIS CHATEAUBRIND" ~ "ASSIS CHATEAUBRIAND",
    uf == "PR" & comarca == "CHOPIZINHO" ~ "CHOPINZINHO",
    uf == "PR" & comarca == "CRUZEIRO DOESTE" ~ "CRUZEIRO DO OESTE",
    uf == "PR" & comarca == "FORMOSA DOESTE" ~ "FORMOSA DO OESTE",
    uf == "PR" & comarca == "COMARCA DA REGIAO METROPOLITINA DE CURITIBA" ~ "CURITIBA",
    uf == "PR" & comarca == "GRANDE RIOS" ~ "GRANDES RIOS",
    uf == "PR" & comarca == "GUATATUBA" ~ "GUARATUBA",
    uf == "PR" & comarca == "MALLLET" ~ "MALLET",
    uf == "PR" & comarca == "MARIALAVA" ~ "MARIALVA",
    uf == "PR" & comarca == "SANTA IZABEL DO IVAI" ~ "SANTA ISABEL DO IVAI",
    uf == "PR" & comarca == "SAO MIGEL DO IGUCU" ~ "SAO MIGUEL DO IGUACU",
    uf == "RJ" & comarca == "BARRA DO PIRAL" ~ "BARRA DO PIRAI",
    uf == "RJ" & comarca == "BOM JESUS DE ITABAPOANA" ~ "BOM JESUS DO ITABAPOANA",
    uf == "RJ" & comarca == "BUZIOS" ~ "ARMACAO DOS BUZIOS",
    uf == "RJ" & comarca == "CACHEIRAS DE MACACU" ~ "CACHOEIRAS DE MACACU",
    uf == "RJ" & comarca == "CARAPEBUS/ QUISSAMA" ~ "CARAPEBUS",
    uf == "RJ" & comarca == "IGUAPA GRANDE" ~ "IGUABA GRANDE",
    uf == "RJ" & comarca == "PORTO REAL QUATIS" ~ "QUATIS",
    uf == "RJ" & comarca == "SAO FRANSCISCO DE ITABAPOANA" ~ "SAO FRANCISCO DE ITABAPOANA",
    uf == "RJ" & comarca == "SAO JOAO DE MERRI" ~ "SAO JOAO DE MERITI",
    uf == "RJ" & comarca == "SILVIA JARDIM" ~ "SILVA JARDIM",
    uf == "RJ" & comarca == "VALENCIA" ~ "VALENCA",
    uf == "RN" & comarca == "ALFONSO BEZERRA" ~ "AFONSO BEZERRA",
    uf == "RN" & comarca == "ALMINO ALFONSO" ~ "ALMINO AFONSO",
    uf == "RN" & comarca == "DIX SEPT ROSADO" ~ "GOVERNADOR DIX SEPT ROSADO",
    uf == "RN" & comarca == "PORTOALEGRE" ~ "PORTALEGRE",
    uf == "RN" & comarca == "JOSE DO CAMPESTRE" ~ "SAO JOSE DO CAMPESTRE",
    uf == "RN" & comarca == "ALECANDRIA" ~ "ALEXANDRIA",
    uf == "RN" & comarca == "CARAUNAS" ~ "CARAUBAS",
    uf == "RN" & comarca == "SAO JOSE DO MIPUBU" ~ "SAO JOSE DE MIPIBU",
    uf == "RO" & comarca == "COLORADO DOESTE" ~ "COLORADO DO OESTE",
    uf == "RO" & comarca == "GUARAJA MIRIM" ~ "GUAJARA MIRIM",
    uf == "RO" & comarca == "OURO PRETO DOESTE" ~ "OURO PRETO DO OESTE",
    uf == "RR" & comarca == "SAO LUIS" ~ "SAO LUIZ",
    uf == "RS" & comarca == "CACHOERINHA DO SUL" ~ "CACHOEIRINHA",
    uf == "RS" & comarca == "CAPAO DA CANCA" ~ "CAPAO DA CANOA",
    uf == "RS" & comarca == "CAIXAS DO SUL" ~ "CAXIAS DO SUL",
    uf == "RS" & comarca == "ELDOURADO DO SUL" ~ "ELDORADO DO SUL",
    uf == "RS" & comarca == "ESPURNOSO" ~ "ESPUMOSO",
    uf == "RS" & comarca == "FAXINAL DO SOTUMO" ~ "FAXINAL DO SOTURNO",
    uf == "RS" & comarca == "GANBALDI" ~ "GARIBALDI",
    uf == "RS" & comarca == "IJUL" ~ "IJUI",
    uf == "RS" & comarca == "JANGUARAO" ~ "JAGUARAO",
    uf == "RS" & comarca == "JULIO CASTILHOS" ~ "JULIO DE CASTILHOS",
    uf == "RS" & comarca == "RESTININGA SECA" ~ "RESTINGA SECA",
    uf == "RS" & comarca == "SANTO ANTONIO DE PATRULHA" ~ "SANTO ANTONIO DA PATRULHA",
    uf == "RS" & comarca == "SAO FRANSCISO DE ASSIS" ~ "SAO FRANCISCO DE ASSIS",
    uf == "RS" & comarca == "SAO FRANSCISCO DE PAULA" ~ "SAO FRANCISCO DE PAULA",
    uf == "RS" & comarca == "SAO JENONIMO" ~ "SAO JERONIMO",
    uf == "RS" & comarca == "MARCOS" ~ "SAO MARCOS",
    uf == "RS" & comarca == "SEPE" ~ "SAO SEPE",
    uf == "RS" & comarca == "VALENTIM" ~ "SAO VALENTIM",
    uf == "RS" & comarca == "SANRANDI" ~ "SARANDI",
    uf == "RS" & comarca == "SOIEDADE" ~ "SOLEDADE",
    uf == "RS" & comarca == "TAPAJARA" ~ "TAPEJARA",
    uf == "RS" & comarca == "TEUTONIO" ~ "TEUTONIA",
    uf == "RS" & comarca == "VENANCIA AIRES" ~ "VENANCIO AIRES",
    uf == "SC" & comarca == "BLUEMENAU" ~ "BLUMENAU",
    uf == "SC" & comarca == "LAJES" ~ "LAGES",
    uf == "SC" & comarca == "SAO MIGUEL DOESTE" ~ "SAO MIGUEL DO OESTE",
    uf == "SC" & comarca == "BLUMENAL" ~ "BLUMENAU",
    uf == "SC" & comarca == "VIDEIRAS" ~ "VIDEIRA",
    uf == "SC" & comarca == "SAO BENTO" ~ "SAO BENTO DO SUL",
    uf == "SC" & comarca == "BALNEARIO CAMBURIU" ~ "BALNEARIO CAMBORIU",
    uf == "SC" & comarca == "IATAJAI" ~ "ITAJAI",
    uf == "SE" & comarca == "NOSSA SENHORA DO. SOCORRO" ~ "NOSSA SENHORA DO SOCORRO",
    uf == "SE" & comarca == "GRACCHO CARDOSO" ~ "GRACHO CARDOSO",
    uf == "SE" & comarca == "ITAPORANGA D AJUDA" ~ "ITAPORANGA DAJUDA",
    uf == "SE" & comarca == "MONTE ALEGRE" ~ "MONTE ALEGRE DE SERGIPE",
    uf == "SE" & comarca == "NOSSA SENHORA DE APARECIDA" ~ "NOSSA SENHORA APARECIDA",
    uf == "SE" & comarca == "SANTOS AMARO DAS BROTAS" ~ "SANTO AMARO DAS BROTAS",
    TRUE ~ comarca
  )) %>%
  left_join(aux_muni, c("uf", "comarca" = "muni", "id_justica")) %>%
  arrange(id_justica, id_tribunal, id_foro)

usethis::use_data(da_foro_comarca, overwrite = TRUE)

# export ------------------------------------------------------------------

da_publico <- da_foro_comarca %>%
  filter(id_justica == "8")

writexl::write_xlsx(da_publico, "data-raw/xlsx/codigos_tribunais_publico.xlsx")
writexl::write_xlsx(da_foro_comarca, "data-raw/xlsx/codigos_tribunais_associados.xlsx")











