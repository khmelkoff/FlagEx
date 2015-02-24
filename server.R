###############################################################################
# FlagEx Server
# author: khmelkoff@gmail.com
###############################################################################
# TODO:
# 1. Add new countries
# 4. Add colors to the map
# 5. UI
###############################################################################


# Load data and libraries #####################################################
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

# Data Processing #############################################################

crosses <- flag_data$V20 + flag_data$V21 # the tot. number of crosses
flag_data <- select(flag_data, old_country = V1, 
                    # colors
                    red = V11,
                    green = V12,
                    blue = V13,
                    gold = V14,
                    white = V15,
                    black = V16,
                    orange = V17,
                    domcolor = V18,
                    # features
                    circles = V19,
                    sunstars = V23,
                    icons = V26,
                    animates = V27)

flag_data <- mutate(flag_data, crosses = crosses)

# Correct the country names
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
# Filter the "actual" countries
flag_data <- filter(flag_data, country != "old")

flag_data <- cbind.data.frame(flag_data$country, flag_data[,2:14], 
                              stringsAsFactors = FALSE)
names(flag_data)[1] <- "country"

# Add new countries
## +Russian Federation
Russia <- data.frame(country = "Russia", 
                    red = 1,
                    green = 0,
                    blue = 1,
                    gold = 0,
                    white = 1,
                    black = 0,
                    orange = 0,
                    domcolor = "red",
                    circles = 0,
                    sunstars = 0,
                    icons = 0,
                    animates = 0,                    
                    crosses = 0)
flag_data <- rbind(flag_data, Russia)
## +Kazakhstan
Kazakhstan <- data.frame(country = "Kazakhstan", 
                     red = 0,
                     green = 1,
                     blue = 1,
                     gold = 1,
                     white = 0,
                     black = 0,
                     orange = 0,
                     domcolor = "blue",
                     circles = 0,
                     sunstars = 1,
                     icons = 1,
                     animates = 1,                    
                     crosses = 0)
flag_data <- rbind(flag_data, Kazakhstan)
## +Belarus
Belarus <- data.frame(country = "Belarus", 
                         red = 1,
                         green = 1,
                         blue = 0,
                         gold = 0,
                         white = 1,
                         black = 0,
                         orange = 0,
                         domcolor = "red",
                         circles = 0,
                         sunstars = 0,
                         icons = 1,
                         animates = 0,                    
                         crosses = 0)
flag_data <- rbind(flag_data, Belarus)
## +Ukraine
Ukraine <- data.frame(country = "Ukraine", 
                      red = 0,
                      green = 0,
                      blue = 1,
                      gold = 1,
                      white = 0,
                      black = 0,
                      orange = 0,
                      domcolor = "blue",
                      circles = 0,
                      sunstars = 0,
                      icons = 0,
                      animates = 0,                    
                      crosses = 0)
flag_data <- rbind(flag_data, Ukraine)

# Server logic ################################################################

shinyServer(function(input, output) {
    
    # Country selector
    selector <- reactive({
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
            
            
            if(input$ftrs != "any") {
                
                if (input$ftrs == "1") {
                    countries <- filter(countries, circles > 0)
                } 
                if (input$ftrs == "2") {
                    countries <- filter(countries, crosses > 0)
                }
                if (input$ftrs == "3") {
                    countries <- filter(countries, sunstars > 0)
                }
                if (input$ftrs == "4") {
                    countries <- filter(countries, icons > 0)
                }
                if (input$ftrs == "5") {
                    countries <- filter(countries, animates > 0)
                }
                
            }
            
          
            countries
         })

    # Country list
    output$cnt <- renderPrint({
            
            ds <- selector()
            
            # Print with out NA function
            cutNA <- function(x) {
                if(!is.na(x)) {
                    cat(x)
                } else {
                    cat(" ")
                }
            } 

            # Format output to 3 columns
            if (nrow(ds)>0) {
                cat("<TABLE BORDER=0 WIDTH=100%>")
                for (i in seq(1, nrow(ds), by=3)) {
                    cat("<TR>")
                    cat("<TD>");cutNA(ds[i,1]);cat("</TD>")
                    cat("<TD>");cutNA(ds[i+1,1]);cat("</TD>")
                    cat("<TD>");cutNA(ds[i+2,1]);cat("</TD>")
                    cat("</TR>")    
                }
                cat("</TABLE>")
            }

    })
    
    # The Number of selected countries
    output$n <- renderPrint({
            
            ds <- selector()
            cat(paste("Countries/Flags:", nrow(ds)))
            
        })
        
    # The worldmap
    output$map <- renderGvis({
            
            ds <- selector()
            gvisGeoChart(ds, locationvar = "country")

        })

})