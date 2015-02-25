###############################################################################
# FlagEx UI
# author: khmelkoff@gmail.com
###############################################################################



library(shiny)
library(googleVis)

# Define UI for application ################################################### 
shinyUI(fluidPage(
    
    # Application title
    title = "The Flag Expert",
    h1("FlagEx"),    
    tags$hr(),
    
    tags$b(
        "Based on the Flags Dataset from the",
        tags$a(href="https://archive.ics.uci.edu/ml/datasets/Flags", 
               "UCI Machine Learning Repository"),
        tags$br(),tags$br()),
    
    sidebarLayout(
        
        # Sidebar with a checkbox, list and radiobuttons
        sidebarPanel(
            
            tags$b("Choose the flag details"),
            tags$br(),
            tags$br(),
            
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
        
        # main panel with two tabs
        mainPanel(
            tabsetPanel (
                tabPanel("Worldmap", htmlOutput("map")),
                tabPanel("Country list",
                         tags$b(p(htmlOutput("n"))),
                         htmlOutput("cnt")                     
                ) 
            )    
        )

    )
))