require(curl)

process_CNEFE <- function(state="all"){
  
  # Dados auxiliares IBGE ---------------------------------------------------
  
  estadosBR <- read_state(year=2020) %>% `st_geometry<-`(NULL)
  
  UF_escolhido_COD <- (estadosBR %>% filter(abbrev_state == UF_escolhido))$code_state
  
  # Download Base CNEFE -----------------------------------------------------
  
  url <- "ftp.ibge.gov.br"
  
  dir_path <- "/Censos/Censo_Demografico_2010/Cadastro_Nacional_de_Enderecos_Fins_Estatisticos/"
  
  dir.create(UF_escolhido)
  
  downloadCNEFE <- curl_fetch_disk(paste0(url,dir_path,"/",UF_escolhido,"/",UF_escolhido_COD,".zip"),paste0(UF_escolhido,'/dadosCNEFE_',UF_escolhido,".zip"))
  
  unzip(downloadCNEFE$content, exdir = UF_escolhido)
  
  
}