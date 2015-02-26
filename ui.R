###############################################################################
# xFlags UI
# author: khmelkoff@gmail.com
###############################################################################



library(shiny)
library(googleVis)

# Define UI for application ################################################### 
shinyUI(fluidPage(

    fluidRow(
        column(12, "",     
        
    # Application title
    
    title = "xFlags",
    h1("The simple flags expert system"),    
    
    
    tags$b(
        "Based on the Flags Dataset from the",
        tags$a(href="https://archive.ics.uci.edu/ml/datasets/Flags", 
               "UCI Machine Learning Repository"),
        tags$hr())
        )
        
    ),
    
    fluidRow(
        column(3, "",

            # Sidebar with a checkbox, list and radiobuttons
            tags$b("Choose the flag details"),
            
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
        column(9, "",
        
            # Main panel with 3 tabs
            tabsetPanel (
                tabPanel("Worldmap", htmlOutput("map")),
                tabPanel("Countries",
                         tags$b(p(htmlOutput("n1"))),
                         htmlOutput("cnt")                     
                ),
                tabPanel("Languages", 
                         tags$b(p(htmlOutput("n2"))),
                         plotOutput("lang", 
                                    width = "500px", 
                                    height = "400px"),
                ) 
            )    
        )
    ),
    
    # Footer
    fluidRow(
        column(12, "",
               tags$hr(),
               tags$small("If you have found a mistake or your country is not listed, please contact",
                    tags$b("khmelkoff@gmail.com") 
                    )
               )
        )
))