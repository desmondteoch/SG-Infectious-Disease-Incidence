# Mon Mar 09 18:34:18 2020 ------------------------------

# This is a shiny app built for the Coursera project:
# Developing Data Products, Assignment 4
#
# This shiny app uses data from the MOH, Singapore on the weekly
# infectious disease burden in Singapore.
# Data is from 2012 to 2019 (total 8 years).
#
# The goal is to display the incidence of the selected infectious disease
# through a plot, and also produce the data in a table format.
#
# The other objective is to run a linear regression model on the selected
# data, to show the trend of the change in incidence over the years.

#Sys.setlocale("LC_ALL","English")

#library(shiny)

# Define server logic to plot time series
shinyServer(function(input, output) {
    
    # data generated based on selected disease(s)
    selectedData <- reactive({
      #data <- read.csv("data.csv", header = TRUE)
      data <- readRDS("data/data.RDS")  
      data$epi_time <- as.yearqtr(data$epi_time, format = "%Y-%q")
      data %>% read.zoo() %>% as.xts()
      
      req(input$disease)
      filter(data, disease %in% input$disease)
    
    })
      
    # plot selected data
    output$plot <- renderPlotly({
      
        # plot for counts
        plot <- plot_ly(selectedData(), 
                        type = "scatter", 
                        mode = "lines+markers",
                        color = ~disease,
                        x = ~epi_time, y= ~total)
        plot <- plot %>% 
          layout(title = "Incidence of Disease over Time", 
                 xaxis = list(rangeslider = list(type = "date"),
                              tickformat = "Q%q %Y",
                              title = "Year", 
                              sep = ""),
                 yaxis = list(title = "No. of Cases")) 
            
    })
    
    # produce selected data as interactive table
    output$table <- renderDataTable({
      
      filter(data, disease %in% input$disease)
      
    })
    
    # run linear regression on selected data
    output$regression <- renderPlotly({
      
        data.lm <- filter(data, disease %in% input$disease)
        fit <- lm(data.lm$total ~ data.lm$epi_time)
        plot.lm <- ggplot(data.lm, 
                          aes(x = data.lm$epi_time, y = data.lm$total)) +
          geom_point() +
          stat_smooth(method = "lm") +
          labs(x = "Year", y = "No. of Cases", 
               title = "Linear Regression Model") +
          theme_minimal()
        
        ggplotly(plot.lm)
        
    })
    
    output$downloadData <- downloadHandler(
      
      filename = function(){
        paste(input$disease, "data.csv", sep = "_")
      },
      content = function(file){
        write.csv(selectedData(), file, row.names = FALSE)
      }
    )

})
