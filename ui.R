#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
require(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Felids in Brazil"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            uiOutput("Genus"),
            uiOutput("Species"),
            span("Table of occurrences of felids in Brazil and their location are displayed dynamically on the right side of the map. You just need to select a genus and a species. Note that :"),
            span(tags$ol(tags$li("Changes on the genus will reset the list of species")
                         ,tags$li("When a species is selected, the map will be automatically updated."))),
           br(),
            span("You can zoom in or out on the map to see the details on the occurrence. A click on any single tick mark will display a popup with details.")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(tabsetPanel(
            tabPanel("Occurrence map",leafletOutput("map"))
        )
        
        )
    )
))
