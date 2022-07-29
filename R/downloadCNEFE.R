# require(curl)

download_CNEFE <- function(state="all",dest_path="",overwrite=FALSE){
  
  # get state code(s)
  
  if(state=="all"){
    
    state_codes <- states$code_state
    
    
  }else{
    
    state_codes <- (states %>% filter(abbrev_state == state))$code_state
    
  }
  
  for(state_code in state_codes){
    
    print(paste0("State: ",states[code_state == state_code,"abbrev_state"]))
    
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
      
      print("Downloading...")
      
      downloadCNEFE <- curl_download(url = download_path,
                                     destfile = file_path,
                                     quiet=FALSE)
    }else{
      
      downloadCNEFE <- paste0(dest_path,'/',state,'/CNEFEdata_',state,".zip")
      
    }
    
    print("Unzipping...")
    
    unzip(downloadCNEFE, exdir = paste0(dest_path,'/',state))
    
  }
}
