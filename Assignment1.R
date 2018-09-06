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

#Define UI for app that shows table and plots a bar
ui <- fluidPage(
  navbarPage("Esophageal Cancer Navigation Bar", 
             theme = shinytheme("journal"),
             tabPanel("Alcohol",
                      sidebarLayout(
                        sidebarPanel(
                          checkboxGroupInput("Age_Select",
                                             "Age:",
                                             choices = levels(cancer$Age_Group),
                                             selected = c("25-34", "35-44"))
                          ),
                        # Output plot
                        mainPanel(
                          plotlyOutput("Alcohol")
                        )
                      )),
             # Data Table
             tabPanel("Tobacco",
                      fluidPage(DT::dataTableOutput("Tobacco"))
             )
  )
)

# Define server logic
server <- function(input, output) {
  output$Alcohol <- renderPlotly({
    cancerdata <- subset(cancer, Age_Group %in% input$Age_Select)
    ggplot(data = cancerdata, aes(x = Alcohol_Use, y = Num_Cases, fill = Age_Group)) + geom_bar(stat = "identity") +
      xlab("Alcohol Use") + ylab("Number of Cases")
    #ggplot(data = cancerdata, aes(x = Tobacco_Use, y = Num_Cases, fill = Age_Group)) + geom_bar(stat = "identity") +
    #  xlab("Tobacco Use") + ylab("Number of Cases")
  })
  output$Tobacco <- DT::renderDataTable({
    subset(cancer, Age_Group %in% input$Age_Select, select = c(Age_Group, Alcohol_Use, Tobacco_Use, Num_Cases, Num_Controls))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)