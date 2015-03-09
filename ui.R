###############################################################################
# xFlags UI
# author: khmelkoff@gmail.com
###############################################################################



suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(googleVis))

# Define UI for application ################################################### 
shinyUI(fluidPage(

    fluidRow(
        column(12, "",     
        
    # Application title
    
    title = "xFlags",
    h1("The simple flag expert system"),    
    
    
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
            
            selectInput("domc", "Predominant color:", 
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
        
            # Main panel with tabs
            tabsetPanel (
                
                tabPanel("Docs", 
                         tags$br(),
                         tags$p(tags$b("xFlags"),"- an application 
                         that allows you to find the country 
                         on the details of its flag", tags$br(), "and look 
                         at the distribution of languages 
                         for a given set of features."),
                         
                         tags$p("Select one of the tabs:", 
                         tags$br(), tags$b("Worldmap"), " - Countries on the world map",
                         tags$br(), tags$b("Countries"), " - List of the countries with flags",
                         tags$br(), tags$b("Languages"), " - language distribution in the chart"),

                         tags$p("Choose a combination of details of the flag:",
                         tags$br(), "The dominant color and/or some flags color 
                         and/or other features (stars, circles, icons).",
                         tags$br(), "Information on the tabs changes 
                         every time you change your selection."),
                         
                         tags$p("Attention! The application uses the data of 1986,
                         revised in a reproducible manner.",
                         tags$br(), "Fixed 31 country name, removed 
                         not actual names (USSR, DDR, Czechoslovakia etc)", 
                         tags$br(), "added 29 new names (e.g. Kazakhstan, Russia)"),
                         
                         tags$p("Used R-packages:",
                         tags$br(), "Shiny, dplyr, googleVis, ggplot2"),
                         
                         tags$p("Flag icon urls: Population data set (googleVis),
                                Icons source: Wikipedia"), 
                         
                         
                         tags$p("Presentation:",
                         tags$br(), tags$a(href="http://khmelkoff.github.io/xFlagspp/index.html", 
                         "http://khmelkoff.github.io/xFlagspp/index.html")), 
                                                   
                         tags$p("Source code:",
                         tags$br(), tags$a(href="http://github.com/khmelkoff/xFlags", 
                         "http://github.com/khmelkoff/xFlags"))                         
                         
                ),
                
                tabPanel("Worldmap", 
                         tags$br(),
                         htmlOutput("map"),
                         tags$br(),
                         tags$p("Region color corresponding to the predominant color of the flag"
                                , align="center")),
                
                tabPanel("Countries",
                         tags$b(p(htmlOutput("n1"))),
                         htmlOutput("cnt")                     
                ),
                tabPanel("Languages", 
                         tags$b(p(htmlOutput("n2"))),
                         plotOutput("lang", 
                                    width = "500px", 
                                    height = "400px")
                )
            )    
        )
    ),
    
    # Footer
    fluidRow(
        column(12, "",
               tags$hr(),
               tags$small("If you have found a mistake or your country is not listed, please contact",
                    tags$a(href="mailto:khmelkoff@gmail.com","khmelkoff@gmail.com") 
                    )
               )
        )
))