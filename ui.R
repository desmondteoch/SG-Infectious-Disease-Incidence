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

# Define UI for shiny app to plot infectious disease burden in SG
shinyUI(fluidPage(

    # Application title
    titlePanel("Infectious Diseases Burden in Singapore"),

    # Sidebar to select for disease(s)
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "disease", 
                        label = "Select Your Disease(s) of Interest",
                        choices = levels(data$disease), 
                        multiple = TRUE,
                        selected = "Dengue Fever"),
            downloadButton("downloadData", "Download Selected Data"),
            helpText(HTML('<br><br><p style="color:grey; font-size:9pt">Source: Weekly Infectious Disease Bulletin, Ministry of Health, Singapore. </p>') )
            ),

        # Show a plot of the data of interest, and relevant table
        mainPanel(
            tabsetPanel(
                tabPanel("Plot", plotlyOutput("plot")),
                tabPanel("Data", dataTableOutput("table")),
                tabPanel("Regression Line", plotlyOutput("regression"))
            )
        )
    )
))
