require(dplyr)

process_CNEFE <- function(path){
  
  paste0(UF_escolhido,"/",UF_escolhido_COD,".txt")
  
  bdCNEFE <- readr::read_fwf(file_path, skip=0, guess_max = 1000000,col_positions = fwf_widths(c(2,5,2,2,4,1,20,30,60,8,7,20,10,20,10,20,10,20,10,20,10,20,10,15,15,60,60,2,40,1,30,3,3,8)))
  
  colnames(bdCNEFE) <- c("Código da UF",
                         "Código do município",
                         "Código do distrito",
                         "Código do subdistrito",
                         "Código do setor",
                         "Situação do setor",
                         "Tipo do logradouro",
                         "Título do logradouro",
                         "Nome do logradouro",
                         "Número no logradouro",
                         "Modificador do número",
                         #"Complemento",
                         "Elemento 1",
                         "Valor 1",
                         "Elemento 2",
                         "Valor 2",
                         "Elemento 3",
                         "Valor 3",
                         "Elemento 4",
                         "Valor 4",
                         "Elemento 5",
                         "Valor 5",
                         "Elemento 6",
                         "Valor 6",
                         "Latitude",
                         "Longitude",
                         "Localidade",
                         "Nulo",
                         "Espécie de endereço",
                         "Identificação estabelecimento",
                         "Indicador de endereço",
                         "identificação domicílio coletivo",
                         "Número da quadra (*)",
                         "Número da face",
                         "CEP"
  )
  
  bdCNEFE_tratado <- bdCNEFE %>% mutate(`Código da UF` = as.numeric(`Código da UF`),
                                        `Código do município` = as.numeric(`Código do município`),
                                        `Código do distrito` = as.numeric(`Código do distrito`),
                                        `Código do subdistrito` = as.numeric(`Código do subdistrito`),
                                        `Código do setor` = as.numeric(`Código do setor`),
                                        
                                        `Tipo do logradouro` = str_trim(`Tipo do logradouro`),
                                        `Título do logradouro` = str_trim(`Título do logradouro`),
                                        `Nome do logradouro` = str_trim(`Nome do logradouro`),
                                        `Modificador do número` = str_trim(`Modificador do número`),
                                        `Elemento 1` = str_trim(`Elemento 1`),
                                        `Elemento 2` = str_trim(`Elemento 2`),
                                        `Elemento 3` = str_trim(`Elemento 3`),
                                        `Elemento 4` = str_trim(`Elemento 4`),
                                        `Elemento 5` = str_trim(`Elemento 5`),
                                        `Elemento 6` = str_trim(`Elemento 6`),
                                        
                                        `Valor 1` = str_trim(`Valor 1`),
                                        `Valor 2` = str_trim(`Valor 2`),
                                        `Valor 3` = str_trim(`Valor 3`),
                                        `Valor 4` = str_trim(`Valor 4`),
                                        `Valor 5` = str_trim(`Valor 5`),
                                        `Valor 6` = str_trim(`Valor 6`),
                                        
                                        Localidade = str_trim(Localidade),
                                        
                                        `Identificação estabelecimento` = as.numeric(str_trim(`Identificação estabelecimento`)),
                                        
                                        `identificação domicílio coletivo` = as.numeric(str_trim(`identificação domicílio coletivo`)),
                                        
                                        Latitude = str_trim(Latitude),
                                        Longitude = str_trim(Longitude),
                                        
                                        Latitude = ifelse(Latitude != "",str_replace(Latitude, " S",""),NA),
                                        Longitude = ifelse(Longitude != "",str_replace(Longitude, " O",""),NA)
  )
  
  bdCNEFE_tratado <- bdCNEFE_tratado %>% mutate(Latitude_tratada = ifelse(is.na(Latitude),NA,as.numeric(str_split_fixed(Latitude," ",3)[,1]) + as.numeric(str_split_fixed(Latitude," ",3)[,2])/60 + as.numeric(str_split_fixed(Latitude," ",3)[,3])/3600 ),
                                                Longitude_tratada = ifelse(is.na(Longitude),NA,as.numeric(str_split_fixed(Longitude," ",3)[,1]) + as.numeric(str_split_fixed(Longitude," ",3)[,2])/60 + as.numeric(str_split_fixed(Longitude," ",3)[,3])/3600)
  )
  
  
  bdCNEFE_tratado <- bdCNEFE_tratado %>% mutate(COD_Setor = paste0(`Código da UF`,sprintf("%05d",`Código do município`),sprintf("%02d",`Código do distrito`),sprintf("%02d",`Código do subdistrito`),sprintf("%04d",`Código do setor`)))
  
  
  saveRDS(bdCNEFE_tratado,paste0("bdCNEFE_",UF_escolhido,".RDS"))
  
}
