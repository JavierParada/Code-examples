#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(ggthemes)

Literacy_wide <- read.csv(file="tableau_literacy_wide.csv", header=TRUE, sep=",")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        x    <- na.omit(Literacy_wide$lit_total)

        output$graph1 = renderPlot({

        ggplot(data = na.omit(Literacy_wide[which(Literacy_wide$urban == input$var),]), aes(lit_total,reorder(state,lit_total))) + 
            geom_point() + ggtitle('Literacy rate national level') +
            labs(x="Literacy rate %", y="State") +xlim(c(50,100)) + 
            theme(text = element_text(size=20))     })
        
    
        output$graph2 = renderPlot({
        
        ggplot(data = na.omit(Literacy_wide[which(Literacy_wide$urban == input$var),]), aes(lit_total,reorder(state,lit_total))) + 
            geom_point() + ggtitle('Literacy rate by gender') +
            geom_errorbarh(aes(xmax = lit_male, xmin =lit_female)) +xlim(c(50,100)) +
            labs(x="Literacy rate %", y="State") + 
            theme(text = element_text(size=20))       })
        
    

})
