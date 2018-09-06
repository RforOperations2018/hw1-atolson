#Author: Andrew Olson
#R Shiny - Homework 1

library(shiny)
library(reshape2)
library(dplyr)
library(plotly)
library(shinythemes)

#loading the data to be used in the UI

cancer <- esoph
#changing variable names to be understandable
colnames(cancer) <- c("Age_Group", "Alcohol_Use", "Tobacco_Use", "Num_Cases", "Num_Controls")
pdf(NULL)

#Define UI for app that shows table and plots a ____
ui <- fluidPage(
  navbarPage("Esophageal Cancer Navigation Bar", 
             theme = shinytheme("journal"),
             tabPanel("Plot",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("Age_Select",
                                      "Age:",
                                      choices = levels(cancer$Age_Group),
                                      multiple = TRUE,
                                      selectize = TRUE,
                                      selected = c("25-34", "35-44", "45-54", "55-64", "65-74", "75+"))
                        ),
                        # Output plot
                        mainPanel(
                          plotlyOutput("plot")
                        )
                      )
             ),
             # Data Table
             tabPanel("Table",
                      fluidPage(DT::dataTableOutput("table"))
             )
  )
)

# Define server logic
server <- function(input, output) {
  output$plot <- renderPlotly({
    cancerdata <- subset(cancer, Age_Group %in% input$Age_Select)
    ggplot(data = cancerdata, aes(x = Age_Group, y = Alcohol_Use, fill = Alcohol_Use)) + geom_bar(, stat = "identity")
  })
  output$table <- DT::renderDataTable({
    subset(cancer, Age_Group %in% input$Age_Select, select = c(Age_Group, Alcohol_Use, Tobacco_Use, Num_Cases, Num_Controls))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)