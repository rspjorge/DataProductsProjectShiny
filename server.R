#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyr)
library(dplyr)
library(leaflet)

# Load file managing the dataset 
source("felids.R") 

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    # Define a dropdown list based on the Genus
    output$Genus <- renderUI({
        selectInput("Genus", "Genus", choices = c("Select Genus", Genus))
    })
    
    # Define a dropdown list based on the Species
    output$Species <- renderUI({
        selectInput("Species", "Species", choices = c("Select Species", Species))
    })
    
    # This reactive variable lists dynamically the occurences of the selected genus and/or species
    ListOcc <- reactive({
        selectedGen <- input$Genus
        selectedEsp <- input$Species
        
        selectedEsp <- ifelse(is.null(selectedEsp), "Select Species",selectedEsp)
        selectedGen <- ifelse(is.null(selectedGen), "Select Genus", selectedGen)
        #ListeOccs <- felids
        filterEsp = TRUE
        filterGen = TRUE
        if (!is.null(selectedEsp) & selectedEsp !="Select Species") {
            filterEsp = (felids$Especie==selectedEsp)
        }
        
        if (!is.null(selectedGen) & selectedGen !="Select Genus") {
            filterGen = (felids$Genero==selectedGen)
        }
        
        #print("filters")
        #print(filterEsp)
        #print(filterGen)
        filter(felids, filterGen & filterEsp)
    })
    
    
    observe({
        myGenero <- input$Genus
        if (is.null(myGenero)) myGenero <- "Select Genus"
        # Filter the Species linked to the selected Genus
        if (myGenero == "Select Genus"){
            
            listeEvtsGenero <- felids 
        }
        else{
            listeEvtsGenero <- felids %>% filter(Genero==myGenero)
        }
        
        listeEsp <- listeEvtsGenero$Especie  %>% unique() %>% sort()
        
        updateSelectInput(session, "Species", choices = c("Select Species", listeEsp))
        
    })
    
    output$View <- DT::renderDataTable({
        checkData <- is.null(ListOcc())
        #print("checkData")
        #print(checkData)
        data_to_load <- if (checkData) 
        {
            felids[, DisplayedColumns]
        } 
        else
        {
            {ListOcc()}[, DisplayedColumns]
        }
        #print("data_to_load")
        #print(data_to_load)
        colnames(data_to_load) <- paste0('<span style="color:blue">', c("Scientific Name", "Common Name", "Date", "Researcher", "Data Base", "State", "Town"), '</span>')
        DT::datatable(data_to_load, escape=FALSE)
        
    },
    options = list(orderClasses = TRUE))
    
    hr()
    output$map <- renderLeaflet({
        
        # get the position for each occurence
        Long <- {ListOcc()}$Longitude
        Lat <-  {ListOcc()}$Latitude
        Descr_Occ <- paste({ListOcc()}$Especie,{ListOcc()}$Data_do_registro,{ListOcc()}$Responsavel_pelo_registro,{ListOcc()}$Sigla_da_base_de_dados,{ListOcc()}$Municipio,{ListOcc()}$Estado_Provincia, sep="; ")
        
        my_map <- leaflet() %>% addTiles() %>% 
            addMarkers(data= {ListOcc()}, lng = Long, lat = Lat, clusterOptions = markerClusterOptions(), popup=paste(Descr_Occ, sep=" "))
        my_map
    })
    
})
