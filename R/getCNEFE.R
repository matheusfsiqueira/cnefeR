#' Download and process CNEFE datasets
#'
#' @description
#' Downloads and processes CNEFE datasets developed from IBGE - Brazilian Institute of Geography and Statistics. Data provided by IBGE consists of a countrywide georeferenced register of addresses, which classifies addresses by type (residential, non-residential, etc.).
#' After locally downloading files from IBGE server, function properly reads prevously downloaded text files from CNEFE, tidies data and treats geographical coordinates of addresses. In case of missing data, imputes coordinates from census tract.
#' @param state state abbreviation of datasets to be downloaded; "all" downloads data from all states.
#' @param dest_path directory path of downloaded files (defaults to current working directory).
#' @param output_type "df" outputs data frame object(s). "sf" outputs a simple features object using geographical coordinated from adresses.
#' @return If you are processing a single brazilian state, function outputs a data frame or sf object; If you are processing "all", output is a list of data frames or a list of sf objects.
#' @examples 
#' temp1 <- get_CNEFE(state="all",dest_path="",output_type="df")
#' temp2 <- get_CNEFE(state="CE",dest_path="",output_type="df")
#' @export
#' 
get_CNEFE <- function(state="all",dest_path="",output_type="df"){
  
  download_CNEFE(state,dest_path,overwrite = TRUE)
  
  output <- process_CNEFE(dest_path,state,output_type)
  
  return(output)
  
}
