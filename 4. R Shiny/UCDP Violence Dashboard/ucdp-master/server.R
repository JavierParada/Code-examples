library(shiny)

library(dplyr)

library(leaflet)

library(DT)

shinyServer(function(input, output) {
  # Import Data and clean it
  
  bb_data <- read.csv("data/ged201.csv", stringsAsFactors = FALSE )
  bb_data <- data.frame(bb_data)
  bb_data$Latitude <-  as.numeric(bb_data$latitude)
  bb_data$Longitude <-  as.numeric(bb_data$longitude)
  bb_data$Best <-  log(bb_data$best)
  bb_data=filter(bb_data, Latitude != "NA") # removing NA values
  bb_data=filter(bb_data, Longitude != "NA") # removing NA values
  
  # new column for the popup label
  
  bb_data <- mutate(bb_data, cntnt=paste0('<strong>Name: </strong>',relid,
                                          '<br><strong>Year: </strong> ',year,
                                          '<br><strong>Type of violence: </strong> ',type_of_violence,
                                          '<br><strong>Fatalities: </strong> ',best,
                                          '<br><strong>Article: </strong>',source_article)) 

  # create a color paletter for category type in the data file
  
  pal <- colorFactor(pal = c("#669E9A", "#E1BB44", "#C33B27"), domain = c("state-based armed conflict", "non-state conflict", "one-sided violence"))
   
  # create the leaflet map  
  output$bbmap <- renderLeaflet({
      leaflet(bb_data) %>% 
      addCircles(lng = ~Longitude, lat = ~Latitude) %>% 
      addTiles() %>%
      addCircleMarkers(data = bb_data, lat =  ~Latitude, lng =~Longitude, 
                       radius = 3, popup = ~as.character(cntnt), 
                       color = ~pal(type_of_violence),
                       stroke = FALSE, fillOpacity = 0.8)%>%
      addLegend(pal=pal, values=bb_data$type_of_violence,opacity=1, na.label = "Not Available")%>%
      addEasyButton(easyButton(
        icon="fa-crosshairs", title="ME",
        onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
        })
  
  #create a data object to display data
  
  output$data <-DT::renderDataTable(datatable(
      bb_data,filter = 'top',
      colnames = c("id","relid","year","type","source","latitude","longitude","country","best","Latitude","Longitude")
  ))

  
})
