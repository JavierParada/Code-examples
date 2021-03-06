library(shiny)
library(leaflet)

navbarPage("UCDP 2014 Data for Syria, Turkey, and Iraq", id="main",
           tabPanel("Map", leafletOutput("bbmap", height=1000)),
           tabPanel("Data", DT::dataTableOutput("data")),
           tabPanel("Read Me",includeMarkdown("readme.md")))



