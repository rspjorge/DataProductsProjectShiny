# load libraries
library(dplyr)
library(tidyr)

# Read data
felids <- read.csv("portalbio_02-09-2019-17-47-42FelidaeThreatened.csv", encoding="UTF-8", sep=";",header=TRUE,stringsAsFactors = FALSE)

#Get the number of observations and the number of columns of the file
nb_obs <- dim(felids)[1]
nb_col <- dim(felids)[2]

# Here we will remove the accents from the column names, to make processing easier. 
col_names <- names(felids)
#print(col_names)
new_col_names <- gsub("è","e",gsub("é","e",gsub(".","_",gsub("...","_",col_names,fixed=TRUE),fixed=TRUE),fixed=TRUE),fixed=TRUE)
Encoding(new_col_names) <- "UTF-8"

colnames(felids) <- new_col_names


# Then we get the list of Genus and Species
Genus <- felids$Genero %>% unique() %>% sort()
Species <- felids$Especie %>% unique() %>% sort()

# At last, we display only the main columns
DisplayedColumns <- c("Nome_cientifico","Nome_comum","Data_do_registro","Responsavel_pelo_registro","Sigla_da_base_de_dados","Estado_Provincia", "Municipio")
