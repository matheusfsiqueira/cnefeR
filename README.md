# Download CNEFE datasets from Brazilian Census (IBGE)
Repository created to help access data from CNEFE, the National Register of Addresses for Statistical Purposes (Cadastro Nacional de Estabelecimentos para Fins Estatísticos) of the 2010 Census, developed by IBGE - Brazilian Institute of Geography and Statistics (Instituto Brasileiro de Geografia e Estatística). Data provided by IBGE consists of a countrywide georeferenced register of addresses, which classifies addresses by type (residential, non-residential, etc.).

[More Info from the official website](https://www.ibge.gov.br/estatisticas/sociais/trabalho/9662-censo-demografico-2010.html) or [Here](https://censo2010.ibge.gov.br/cnefe/)

Although it is possible to access and download the CNEFE files directly from IBGE's server [(here)](https://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Cadastro_Nacional_de_Enderecos_Fins_Estatisticos), the large volume of files makes it impractical to deal with this database. This repository presents auxiliary functions that allow you to easily download the IBGE data and process them in a fast way, generating a manipulable database with few lines of code.

## Installation in R
``` R
devtools::install_github("matheusfsiqueira/cnefe_R")
  library(cnefe_R)
```
## Usage
The package is very simple to use, consisting of three functions:

 - `download_CNEFE`: downloads selected CNEFE datasets from IBGE server and saves to local directory;
 - `process_CNEFE`: properly reads text files from CNEFE, tidies data and treats geographical coordinates of addresses. In case of missing data, imputes coordinates from census tract;
 -  `get_CNEFE`: calls previous functions together: downloads, processes and treats CNEFE data, providing a ready-to-use output for your needs/applications.

### Downloading CNEFE data
Function `download_CNEFE` has only 3 arguments. 
- State abbreviation (see note below), or "all" to download data from all states (may take some time);
- Relative destination path (defaults to working directory);
- Overwrite files, or otherwise use previously downloaded data if available.
```r
library(cnefeR)

download <- download_CNEFE(state="all",
                          dest_path="",
                          overwrite=FALSE)
```
Function outputs a string vector of the local paths of zip files downloaded from IBGE server.

### Processing CNEFE data
Function `process_CNEFE` has 3 arguments as well. 
- Relative destination path of downloaded CNEFE files (defaults to working directory);
- State abbreviation (see note below), or "all" to process data from all downloaded states (may cause high memory usage);
- Output type, one of "df","sf". Sf option converts addresses to simple features (spatial format).
```r
library(cnefeR)

process <- process_CNEFE(dest_path="",
                         state="all",
                         output_type="df")
```
If you are processing a single brazilian state, function outputs a data frame or sf object; If you are processing "all", output is a list of data frames or a list of sf objects.

### Download and process CNEFE data
Function `get_CNEFE` combines previous functions, downloading and processing CNEFE data from selected state(s). Arguments are:
- State abbreviation (see note below), or "all" to process data from all downloaded states (may cause high memory usage);
- Relative destination path of downloaded CNEFE files (defaults to working directory);
- Output type, one of "df","sf". Sf option converts addresses to simple features (spatial format).
```r
library(cnefeR)

cnefeData <- get_CNEFE(state="all",
                      dest_path="",
                      output_type="df")
```
If you are processing a single brazilian state, function outputs a data frame or sf object; If you are processing "all", output is a list of data frames or a list of sf objects.

### Brazilian state abbreviations
For brazilian users, this should be trivial. Just as a reminder:
| State | Abbreviation |
|--|--|
| Acre | AC |
| Alagoas | AL |
| Amazonas | AM |
| Amapá | AP |
| Bahia | BA |
| Ceará | CE |
| Distrito Federal | DF |
| Espírito Santo | ES |
| Goiás | GO |
| Maranhão | MA |
| Minas Gerais | MG |
| Mato Grosso do Sul | MS |
| Mato Grosso | MT |
| Pará | PA |
| Paraíba | PB |
| Pernambuco | PE |
| Piauí | PI |
| Paraná | PR |
| Rio de Janeiro | RJ |
| Rio Grande do Norte | RN |
| Rondônia | RO |
| Roraima | RR |
| Rio Grande do Sul | RS |
| Santa Catarina | SC |
| Sergipe | SE |
| São Paulo | SP |
| Tocantins | TO |
