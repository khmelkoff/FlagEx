library(shiny)
library(dplyr)
#library(spam)
#suppressPackageStartupMessages(library(googleVis))
library(googleVis)

url1 <- "https://archive.ics.uci.edu/ml/machine-learning-databases/flags/flag.data"
url2 <- "https://archive.ics.uci.edu/ml/machine-learning-databases/flags/flag.names"

if (!file.exists("flag.data")) {
    file.create("flag.data")
    download.file(url1, "flag.data")
}

if (!file.exists("flag.names")) {
    file.create("flag.names")
    download.file(url2, "flag.names")
}


flag_data <- read.csv("flag.data", header = FALSE, as.is=TRUE)
flag_names <- read.csv("flag.names", as.is=TRUE)

flag_data <- select(flag_data, old_country = V1, 
                    red = V11,
                    green = V12,
                    blue = V13,
                    gold = V14,
                    white = V15,
                    black = V16,
                    orange = V17,
                    domcolor = V18)

# Correct country names
corrNames <- function(x) {
    x <- gsub("-", " ", x) 
    x <- sub("Antigua Barbuda", "Antigua and Barbuda", x)
    x <- sub("Argentine", "Argentina", x)
    x <- sub("British Virgin Isles", "old", x)
    x <- sub("Brunei", "Brunei Darussalam", x)
    x <- sub("Burkina", "Burkina Faso", x)
    x <- sub("Burma", "Myanmar", x)
    x <- sub("Cape Verde Islands", "Cabo Verde", x)
    x <- sub("Comorro Islands", "Comoros", x)
    x <- sub("Czechoslovakia", "old", x)
    x <- sub("Faeroes", "Faroe Islands", x)
    x <- sub("Falklands Malvinas", "Falkland Islands (Malvinas)", x)
    x <- sub("Germany DDR", "old", x)
    x <- sub("Germany FRG", "Germany", x) 
    x <- sub("Guinea Bissau", "Guinea-Bissau", x) 
    x <- sub("Ivory Coast", "Cote d'Ivoire", x) 
    x <- sub("Malagasy", "Madagascar", x) 
    x <- sub("Maldive Islands", "Maldives", x) 
    x <- sub("Marianas", "old", x)
    x <- sub("Sao Tome", "Sao Tome and Principe", x) 
    x <- sub("South Yemen", "Yemen", x)
    x <- sub("St Helena", "Saint Helena", x) 
    x <- sub("St Kitts Nevis", "Saint Kitts and Nevis", x)
    x <- sub("St Lucia", "Saint Lucia", x) 
    x <- sub("St Vincent", "Saint Vincent", x)
    x <- sub("Surinam", "Suriname", x) 
    x <- sub("Trinidad Tobago", "Trinidad and Tobago", x)
    x <- sub("Turks Cocos Islands", "Turks and Caicos Islands", x) 
    x <- sub("UAE", "United Arab Emirates", x)
    x <- sub("US Virgin Isles", "Virgin Islands, U.S.", x) 
    x <- sub("UK", "United Kingdom", x)
    x <- sub("USA", "United States", x) 
    x <- sub("USSR", "old", x)    
    x <- sub("Vatican City", "Vatican", x)
    x <- sub("Vietnam", "Viet Nam", x)
    x <- sub("Yugoslavia", "old", x)
    x <- sub("Western Samoa", "Samoa", x)    
    x <- sub("Zaire", "Kongo", x)    
}

country_names <- flag_data[,1]
country_names <- sapply(country_names, corrNames)

flag_data <- mutate(flag_data, country=country_names)
flag_data <- filter(flag_data, country != "old")

#### Change that after add new features
flag_data <- cbind.data.frame(flag_data$country, flag_data[,2:9], stringsAsFactors = FALSE)
names(flag_data)[1] <- "country"

# Add new countries
## Russian Federation
Russia <- data.frame(country = "Russia", 
                    red = 1,
                    green = 0,
                    blue = 1,
                    gold = 0,
                    white = 1,
                    black = 0,
                    orange = 0,
                    domcolor = "blue")
flag_data <- rbind(flag_data, Russia)


# Define server logic required to generate and plot ....
shinyServer(function(input, output) {

   
        n <- nrow(flag_data)
    
    
        cntds <- reactive({
            countries <- flag_data
            if(input$domc != "any"){
                countries <- filter(countries, domcolor==input$domc)
            }
            
            
            if("1" %in%  input$cbx){
                countries <- filter(countries, red==1)
            }
            if("2" %in%  input$cbx) {
                countries <- filter(countries, green==1)
            }            
            if("3" %in%  input$cbx){
                countries <- filter(countries, blue==1)
            }
            if("4" %in%  input$cbx) {
                countries <- filter(countries, gold==1)
            } 
            if("5" %in%  input$cbx){
                countries <- filter(countries, white==1)
            }
            if("6" %in%  input$cbx) {
                countries <- filter(countries, black==1)
            }
            if("7" %in%  input$cbx) {
                countries <- filter(countries, orange==1)
            }           
            
            countries
            
            
        })

        output$cnt <- renderPrint({
            
            ds <- cntds()
            ds[,1]
            
            })
        
        output$diag <- renderPrint({
            
            ds <- cntds()
            nrow(ds)
            
        })
        
        output$map <- renderGvis({
            
            ds <- cntds()
            gvisGeoChart(ds, locationvar = "country")

        })


})