library(shiny)

# Define UI for application 
shinyUI(pageWithSidebar(
    
    # Application title
    headerPanel("Flag Expert"),
    
    # Sidebar with a checkbox
    sidebarPanel(
        h3("Flag details"),
        selectInput("domc", "Dominant color:", 
                    choices = c("any", "black", "blue",
                                "brown", "gold",
                                "green", "orange",
                                "red", "white")),
        checkboxGroupInput("cbx", "Flag colors:",
                           c("Red"="1",
                             "Green" = "2",
                             "Blue" = "3",
                             "Gold/Yellow" = "4",
                             "White" = "5",
                             "Black" = "6",
                             "Orange" = "7"
                             ))
        
    ),
    
    # 
    mainPanel(
        h3("Countries"),
        htmlOutput("map"),
        textOutput("cnt"),
        verbatimTextOutput("diag")
    )
))