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

#Define UI for app that shows table and plots a bar chart
ui <- fluidPage(
  navbarPage("Esophageal Cancer Navigation Bar", 
             theme = shinytheme("journal"),
             tabPanel("Graph",
                      sidebarLayout(
                        sidebarPanel(
                          checkboxGroupInput("Age_Select",
                                             "Age:",
                                             choices = levels(cancer$Age_Group),
                                             selected = c("25-34", "35-44", "45-54","55-64"))
                          ),
                        # Output barplot
                        mainPanel(
                          plotlyOutput("Graph")
                        )
                      )),
             # Data Table
             tabPanel("Table",
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("Cause_Select",
                                             "Age:", # Mislabeled!
                                             choices = c("Tobacco Use", "Alcohol Use"),
                                             selected = c("Tobacco Use"))
                        ),
                        mainPanel(
                          fluidRow(DT::dataTableOutput("Table")))
             ))
  )
)

# Define server logic
server <- function(input, output) {
  output$Graph <- renderPlotly({
    cancerdata <- subset(cancer, Age_Group %in% input$Age_Select)
    ggplot(data = cancer, aes(x = Alcohol_Use, y = Num_Cases, fill = Age_Group)) + geom_bar(stat = "identity") +
     labs(title = "Esophogeal Cancer Cases Related to Alcohol", x ="Alcohol Use", y = "Number of Cases", fill = "Age Group")
  })
  output$Table <- DT::renderDataTable({
    subset(cancer, select = c(Age_Group, Alcohol_Use, Tobacco_Use, Num_Cases, Num_Controls))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)