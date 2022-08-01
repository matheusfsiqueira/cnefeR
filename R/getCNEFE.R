
get_CNEFE <- function(state="all",dest_path="",output_type="df"){
  
  download_CNEFE(state,dest_path,overwrite = TRUE)
  
  output <- process_CNEFE(dest_path,state,output_type)
  
  return(output)
  
}
