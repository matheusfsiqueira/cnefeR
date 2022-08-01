#' Download CNEFE datasets
#'
#' @description
#' Downloads CNEFE datasets developed from IBGE - Brazilian Institute of Geography and Statistics. Data provided by IBGE consists of a countrywide georeferenced register of addresses, which classifies addresses by type (residential, non-residential, etc.).
#' @param state state abbreviation of datasets to be downloaded; "all" downloads data from all states
#' @param dest_path destination directory of downloaded files (defaults to current working directory)
#' @param overwrite whether to overwrite previosly downloaded files (if present) or not
#' @return local path of downloaded compressed files from IBGE
#' @examples 
#' temp1 <- download_CNEFE(state="all",dest_path="",overwrite=FALSE)
#' temp2 <- download_CNEFE(state="CE",dest_path="",overwrite=TRUE)
#' @export

# require(curl)

download_CNEFE <- function(state="all",dest_path="",overwrite=FALSE){
  
  statesBR <- data(statesBR)
  
  # get state code(s)
  
  if(state=="all"){
    
    state_codes <- statesBR$code_state
    
    
  }else{
    
    state_codes <- (statesBR %>% filter(abbrev_state == state))$code_state
    
  }
  
  downloadCNEFE_files <- c()
  
  for(state_code in state_codes){
    
    message(paste0("State: ",statesBR[code_state == state_code,"abbrev_state"]))
    
    # create subdirectory
    
    dir.create(paste0(dest_path,"/",state), showWarnings = FALSE)
    
    # set download path
    
    url <- "ftp://ftp.ibge.gov.br"
    
    ftp_path <- "/Censos/Censo_Demografico_2010/Cadastro_Nacional_de_Enderecos_Fins_Estatisticos/"
    
    download_path <- paste0(url,ftp_path,"/",state,"/",state_code,".zip")
    
    
    # check if file exists
    
    file_path <- paste0(dest_path,'/',state,'/CNEFEdata_',state,".zip")
    
    file_status <- "not_exists"
    
    if (file.exists(file_path)) {
      
      file_status <- "exists"
      
    }
    
    # download w/ curl if needed
    
    if(overwrite & file_status == "exists"){
      
      #Delete file if it exists
      file.remove(file_path)
      
    }
    
    if(file_status == "not_exists" | overwrite){
      
      message("Downloading... May take a few moments.")
      
      downloadCNEFE <- curl_download(url = download_path,
                                     destfile = file_path,
                                     quiet=FALSE)
    }else{
      
      downloadCNEFE <- paste0(dest_path,'/',state,'/CNEFEdata_',state,".zip")
      
    }
    
    message("Unzipping downloaded files...")
    
    unzip(downloadCNEFE, exdir = paste0(dest_path,'/',state))
    
    downloadCNEFE_files <- c(downloadCNEFE_files,downloadCNEFE)
    
  }
  return(downloadCNEFE_files)
}
