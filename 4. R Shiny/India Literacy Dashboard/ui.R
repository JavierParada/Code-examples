#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)


# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("India Literacy Rates 2017"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            
            
            "Description: The literacy rate in India among people of 7 years of age and above is  77.7%. It was 73.5% in rural areas and 87.7% in urban areas.  Male literacy rates are larger than female literacy rates in all of India. Rajasthan stands out as the state with the largest gap between male and female rural literacy rates. Andhra Pradesh is the state with the lowest literacy rate. Kerala is not only the state with the highest literacy rate, but also the state with the smallest gap between male and female literacy rates.", 
            helpText("Source: Key indicators of household social consumption on education from Indian NSS 75th round (July 2017- June 2018). See Table 2.1 in report."),
                         
            
            selectInput("var", label = "Choose a variable to display:",
                        choices = c("Rural", "Urban","Total"), selected = "Rural")
        ),
        


        # Show a plot of the generated distribution
        mainPanel(
            h3("Range between male and female literacy rates by state"),
            plotOutput("graph1"),
            plotOutput("graph2")
        )
    )
))
