library(shiny)

# Define UI for application 
shinyUI(pageWithSidebar(
    
    # Application title
    headerPanel(
        h1("FlagExpert")
        
                ),
    
    # Sidebar with a checkbox, list and radiobuttons
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
                             )),
        radioButtons("ftrs", "Features:",
                     c("Any" = "any",
                       "Circles" = "1",
                       "Crosses" = "2",
                       "Sun/Stars" = "3",
                       "Icons" = "4",
                       "Animates" = "5"))
        
    ),
    
    # 
    mainPanel(
        htmlOutput("n"),
        tags$hr(),
        htmlOutput("map"),
        tags$hr(),
        htmlOutput("cnt")
    )
))