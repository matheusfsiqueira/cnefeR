#' Process and treat previously downloaded CNEFE datasets
#'
#' @description
#' Properly reads prevously downloaded text files from CNEFE, tidies data and treats geographical coordinates of addresses. In case of missing data, imputes coordinates from census tract.
#' @param dir_path directory path of downloaded files (defaults to current working directory).
#' @param state state abbreviation of datasets to be downloaded; "all" downloads data from all states.
#' @param output_type "df" outputs data frame object(s). "sf" outputs a simple features object using geographical coordinated from adresses.
#' @return If you are processing a single brazilian state, function outputs a data frame or sf object; If you are processing "all", output is a list of data frames or a list of sf objects.
#' @examples 
#' temp1 <- process_CNEFE(dir_path="",state="all",output_type="df")
#' temp2 <- process_CNEFE(dir_path="",state="CE",output_type="df")
#' @export

# require(dplyr)
# require(readr)
# require(stringr)
# require(sf)

process_CNEFE <- function(dir_path,state="all",output_type="df"){
  
  files <- list.files(path = dir_path, pattern = ".txt", full.names = TRUE, recursive = TRUE)
  
  if(state != "all"){
    
    files <- files[grepl(paste0("/",state,"/"),files)==TRUE]
    
  }
  
  bdCNEFE_tratado_list <- list()
  
  for(file in files){
    
    state <- gsub(".txt","",basename(dirname(file)))
    
    message(paste0("State: ",state))
    
    message("Reading text file...")
    
    bdCNEFE <- readr::read_fwf(file, 
                               skip=0, 
                               guess_max = 1000000,
                               col_positions = readr::fwf_widths(c(2,5,2,2,4,1,20,30,60,8,7,20,10,20,10,20,10,20,10,20,10,20,10,15,15,60,60,2,40,1,30,3,3,8)),
                               show_col_types = FALSE)
    
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
    
    message("Post-treatment...")
    
    bdCNEFE_tratado <- bdCNEFE %>% mutate(`Código da UF` = as.numeric(`Código da UF`),
                                          `Código do município` = as.numeric(`Código do município`),
                                          `Código do distrito` = as.numeric(`Código do distrito`),
                                          `Código do subdistrito` = as.numeric(`Código do subdistrito`),
                                          `Código do setor` = as.numeric(`Código do setor`),
                                          
                                          `Tipo do logradouro` = stringr::str_trim(`Tipo do logradouro`),
                                          `Título do logradouro` = stringr::str_trim(`Título do logradouro`),
                                          `Nome do logradouro` = stringr::str_trim(`Nome do logradouro`),
                                          `Modificador do número` = stringr::str_trim(`Modificador do número`),
                                          `Elemento 1` = stringr::str_trim(`Elemento 1`),
                                          `Elemento 2` = stringr::str_trim(`Elemento 2`),
                                          `Elemento 3` = stringr::str_trim(`Elemento 3`),
                                          `Elemento 4` = stringr::str_trim(`Elemento 4`),
                                          `Elemento 5` = stringr::str_trim(`Elemento 5`),
                                          `Elemento 6` = stringr::str_trim(`Elemento 6`),
                                          
                                          `Valor 1` = stringr::str_trim(`Valor 1`),
                                          `Valor 2` = stringr::str_trim(`Valor 2`),
                                          `Valor 3` = stringr::str_trim(`Valor 3`),
                                          `Valor 4` = stringr::str_trim(`Valor 4`),
                                          `Valor 5` = stringr::str_trim(`Valor 5`),
                                          `Valor 6` = stringr::str_trim(`Valor 6`),
                                          
                                          Localidade = stringr::str_trim(Localidade),
                                          
                                          `Identificação estabelecimento` = stringr::str_trim(`Identificação estabelecimento`),
                                          
                                          `identificação domicílio coletivo` = stringr::str_trim(`identificação domicílio coletivo`),
                                          
                                          COD_Setor = paste0(`Código da UF`,sprintf("%05d",`Código do município`),sprintf("%02d",`Código do distrito`),sprintf("%02d",`Código do subdistrito`),sprintf("%04d",`Código do setor`)),
                                          
                                          Latitude = stringr::str_trim(Latitude),
                                          Longitude = stringr::str_trim(Longitude)
    )
    
    # Treating geographic coordinates
    
    bdCNEFE_tratado <- bdCNEFE_tratado %>% mutate(tipo_Latitude = ifelse(grepl(" S$",Latitude),"Sul",ifelse(grepl(" N$",Latitude),"Norte","N/A")),
                                                  
                                                  Latitude = ifelse(!is.na(Latitude),str_remove(str_remove(Latitude, " S")," N"),NA),
                                                  Longitude = ifelse(!is.na(Longitude),str_remove(str_remove(Longitude, " O")," L"),NA),
                                                  
                                                  Latitude_treated = ifelse(is.na(Latitude),NA, as.numeric(str_split_fixed(Latitude," ",3)[,1]) + as.numeric(str_split_fixed(Latitude," ",3)[,2])/60 + as.numeric(str_split_fixed(Latitude," ",3)[,3])/3600 ),
                                                  Longitude_treated = ifelse(is.na(Longitude),NA, as.numeric(str_split_fixed(Longitude," ",3)[,1]) + as.numeric(str_split_fixed(Longitude," ",3)[,2])/60 + as.numeric(str_split_fixed(Longitude," ",3)[,3])/3600),
                                                  
                                                  Latitude_treated = Latitude_treated * ifelse(tipo_Latitude == "Sul",-1,1), # south, negative
                                                  Longitude_treated = Longitude_treated * -1, # west, negative
    )
    
    # Use lat/long from census tract when coordinates not present
    
    bdCNEFE_tratado <- bdCNEFE_tratado %>% left_join(censusTractsBR, by = c("COD_Setor"="code_tract"))
    
    bdCNEFE_tratado <- bdCNEFE_tratado %>% mutate(Longitude_treated = ifelse(!is.na(Longitude_treated), Longitude_treated,X),
                                                  Latitude_treated = ifelse(!is.na(Latitude_treated), Latitude_treated,Y),
                                                  Coords_Source = ifelse(is.na(Latitude) & !is.na(Latitude_treated),"Imputed from Census Tract","Originally Collected")
    )
    
    # Output
    
    bdCNEFE_tratado <- bdCNEFE_tratado %>% select(-one_of("X","Y","tipo_Latitude"))
    
    if(output_type=="sf"){
      
      bdCNEFE_tratado <- bdCNEFE_tratado %>% filter(!is.na(Latitude_treated) & !is.na(Longitude_treated)) %>% st_as_sf(coords=c("Longitude_treated","Latitude_treated"), crs=4326)
      
    }
    
    if(state =="all"){
    
      bdCNEFE_tratado_list[[state]] <- bdCNEFE_tratado
    
    }else{
      
      bdCNEFE_tratado_list <- bdCNEFE_tratado
      
    }
    
  }
  
  return(bdCNEFE_tratado_list)
  
}
