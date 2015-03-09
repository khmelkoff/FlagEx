###############################################################################
# xFlags Server
# author: khmelkoff@gmail.com
###############################################################################


# Load data and libraries #####################################################
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(googleVis))
library(ggplot2)


# data
url1 <- "https://archive.ics.uci.edu/ml/machine-learning-databases/flags/flag.data"

# codebook
#url2 <- "https://archive.ics.uci.edu/ml/machine-learning-databases/flags/flag.names"

if (!file.exists("flag.data")) {
    file.create("flag.data")
    download.file(url1, "flag.data")
}

# if (!file.exists("flag.names")) {
#     file.create("flag.names")
#     download.file(url2, "flag.names")
# }

flag_data <- read.csv("flag.data", header = FALSE, as.is=TRUE)
# flag_names <- read.csv("flag.names", as.is=TRUE)

# Data Processing #############################################################

# crosses + saltires
crosses <- flag_data$V20 + flag_data$V21 # the total number of crosses

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
                    language = V6,
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
    x <- sub("Burkina", "Burkina Faso", x)
    x <- sub("Burma", "Myanmar", x)
    x <- sub("Cape Verde Islands", "Cape Verde", x)
    x <- sub("Comorro Islands", "Comoros", x)
    x <- sub("Congo", "DR Congo", x)
    x <- sub("Czechoslovakia", "old", x)
    x <- sub("Faeroes", "Faroe Islands", x)
    x <- sub("Falklands Malvinas", "Falkland Islands (Malvinas)", x)
    x <- sub("Germany DDR", "old", x)
    x <- sub("Germany FRG", "Germany", x) 
    x <- sub("Guinea Bissau", "Guinea-Bissau", x) 
    x <- sub("Ivory Coast", "Cote d'Ivoire", x)
    x <- sub("Kampuchea", "Cambodia", x)
    x <- sub("Malagasy", "Madagascar", x) 
    x <- sub("Maldive Islands", "Maldives", x) 
    x <- sub("Marianas", "old", x)
    x <- sub("Micronesia", "Federated States of Micronesia", x)
    x <- sub("Parguay", "Paraguay", x)
    x <- sub("Sao Tome", "Sao Tome and Principe", x)
    x <- sub("Soloman Islands", "Solomon Islands", x)
    x <- sub("South Yemen", "Yemen", x)
    x <- sub("St Helena", "Saint Helena", x) 
    x <- sub("St Kitts Nevis", "Saint Kitts and Nevis", x)
    x <- sub("St Lucia", "Saint Lucia", x) 
    x <- sub("St Vincent", "Saint Vincent and the Grenadines", x)
    x <- sub("Surinam", "Suriname", x) 
    x <- sub("Trinidad Tobago", "Trinidad and Tobago", x)
    x <- sub("Turks Cocos Islands", "Turks and Caicos Islands", x) 
    x <- sub("UAE", "United Arab Emirates", x)
    x <- sub("US Virgin Isles", "Virgin Islands, U.S.", x) 
    x <- sub("UK", "United Kingdom", x)
    x <- sub("USA", "United States", x) 
    x <- sub("USSR", "old", x)    
#    x <- sub("Vatican City", "Vatican", x)
#    x <- sub("Vietnam", "Viet Nam", x)
    x <- sub("Yugoslavia", "old", x)
    x <- sub("Western Samoa", "Samoa", x)    
    x <- sub("Zaire", "Kongo", x)    
}

country_names <- flag_data[,1]
country_names <- sapply(country_names, corrNames)

flag_data <- mutate(flag_data, country=country_names)
# Filter the "actual" countries
flag_data <- filter(flag_data, country != "old")

flag_data <- cbind.data.frame(flag_data$country, flag_data[,2:15], 
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
                    language = 5,
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
                     language = 6,
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
                         language = 5,
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
                      language = 5,
                      circles = 0,
                      sunstars = 0,
                      icons = 0,
                      animates = 0,                    
                      crosses = 0)
flag_data <- rbind(flag_data, Ukraine)

## +Estonia
Estonia <- data.frame(country = "Estonia", 
                      red = 0,
                      green = 0,
                      blue = 1,
                      gold = 0,
                      white = 1,
                      black = 1,
                      orange = 0,
                      domcolor = "black",
                      language = 5,
                      circles = 0,
                      sunstars = 0,
                      icons = 0,
                      animates = 0,                    
                      crosses = 0)
flag_data <- rbind(flag_data, Estonia)

## +Latvia
Latvia <- data.frame(country = "Latvia", 
                      red = 1,
                      green = 0,
                      blue = 0,
                      gold = 0,
                      white = 1,
                      black = 0,
                      orange = 0,
                      domcolor = "brown",
                      language = 5,
                      circles = 0,
                      sunstars = 0,
                      icons = 0,
                      animates = 0,                    
                      crosses = 0)
flag_data <- rbind(flag_data, Latvia)

## +Lithuania
Lithuania <- data.frame(country = "Lithuania", 
                     red = 1,
                     green = 1,
                     blue = 0,
                     gold = 1,
                     white = 0,
                     black = 0,
                     orange = 0,
                     domcolor = "green",
                     language = 5,
                     circles = 0,
                     sunstars = 0,
                     icons = 0,
                     animates = 0,                    
                     crosses = 0)
flag_data <- rbind(flag_data, Lithuania)

## +Armenia
Armenia <- data.frame(country = "Armenia", 
                        red = 1,
                        green = 0,
                        blue = 1,
                        gold = 1,
                        white = 0,
                        black = 0,
                        orange = 0,
                        domcolor = "red",
                        language = 5,
                        circles = 0,
                        sunstars = 0,
                        icons = 0,
                        animates = 0,                    
                        crosses = 0)
flag_data <- rbind(flag_data, Armenia)

## +Azerbaijan
Azerbaijan <- data.frame(country = "Azerbaijan", 
                      red = 1,
                      green = 1,
                      blue = 1,
                      gold = 0,
                      white = 0,
                      black = 0,
                      orange = 0,
                      domcolor = "green",
                      language = 9,
                      circles = 0,
                      sunstars = 1,
                      icons = 1,
                      animates = 0,                    
                      crosses = 0)
flag_data <- rbind(flag_data, Azerbaijan)

## +Georgia
Georgia <- data.frame(country = "Georgia", 
                         red = 1,
                         green = 0,
                         blue = 0,
                         gold = 0,
                         white = 1,
                         black = 0,
                         orange = 0,
                         domcolor = "white",
                         language = 10,
                         circles = 0,
                         sunstars = 0,
                         icons = 0,
                         animates = 0,                    
                         crosses = 1)
flag_data <- rbind(flag_data, Georgia)

## +Kyrgyzstan
Kyrgyzstan <- data.frame(country = "Kyrgyzstan", 
                      red = 1,
                      green = 0,
                      blue = 0,
                      gold = 1,
                      white = 0,
                      black = 0,
                      orange = 0,
                      domcolor = "red",
                      language = 9,
                      circles = 0,
                      sunstars = 1,
                      icons = 1,
                      animates = 0,                    
                      crosses = 0)
flag_data <- rbind(flag_data, Kyrgyzstan)

## +Tajikistan
Tajikistan <- data.frame(country = "Tajikistan", 
                         red = 1,
                         green = 1,
                         blue = 0,
                         gold = 1,
                         white = 1,
                         black = 0,
                         orange = 0,
                         domcolor = "white",
                         language = 10,
                         circles = 0,
                         sunstars = 1,
                         icons = 1,
                         animates = 0,                    
                         crosses = 0)
flag_data <- rbind(flag_data, Tajikistan)

## +Turkmenistan
Turkmenistan <- data.frame(country = "Turkmenistan", 
                         red = 1,
                         green = 1,
                         blue = 0,
                         gold = 1,
                         white = 1,
                         black = 0,
                         orange = 0,
                         domcolor = "green",
                         language = 9,
                         circles = 0,
                         sunstars = 0,
                         icons = 1,
                         animates = 0,                    
                         crosses = 0)
flag_data <- rbind(flag_data, Turkmenistan)

## +Uzbekistan
Uzbekistan <- data.frame(country = "Uzbekistan", 
                           red = 1,
                           green = 1,
                           blue = 1,
                           gold = 0,
                           white = 1,
                           black = 0,
                           orange = 0,
                           domcolor = "white",
                           language = 9,
                           circles = 0,
                           sunstars = 1,
                           icons = 0,
                           animates = 0,                    
                           crosses = 0)
flag_data <- rbind(flag_data, Uzbekistan)

## +Bosnia and Herzegovina
Bosnia <- data.frame(country = "Bosnia and Herzegovina", 
                         red = 0,
                         green = 0,
                         blue = 1,
                         gold = 1,
                         white = 1,
                         black = 0,
                         orange = 0,
                         domcolor = "blue",
                         language = 5,
                         circles = 0,
                         sunstars = 1,
                         icons = 0,
                         animates = 0,                    
                         crosses = 0)
flag_data <- rbind(flag_data, Bosnia)

## +Croatia
Croatia <- data.frame(country = "Croatia", 
                     red = 1,
                     green = 0,
                     blue = 1,
                     gold = 1,
                     white = 1,
                     black = 0,
                     orange = 0,
                     domcolor = "white",
                     language = 5,
                     circles = 0,
                     sunstars = 1,
                     icons = 1,
                     animates = 1,                    
                     crosses = 0)
flag_data <- rbind(flag_data, Croatia)

## +Czech Republic
Czech <- data.frame(country = "Czech Republic", 
                      red = 1,
                      green = 0,
                      blue = 1,
                      gold = 0,
                      white = 1,
                      black = 0,
                      orange = 0,
                      domcolor = "red",
                      language = 5,
                      circles = 0,
                      sunstars = 0,
                      icons = 0,
                      animates = 0,                    
                      crosses = 0)
flag_data <- rbind(flag_data, Czech)

## +Serbia
Serbia <- data.frame(country = "Serbia", 
                    red = 1,
                    green = 0,
                    blue = 1,
                    gold = 1,
                    white = 1,
                    black = 0,
                    orange = 0,
                    domcolor = "red",
                    language = 5,
                    circles = 0,
                    sunstars = 0,
                    icons = 1,
                    animates = 1,                    
                    crosses = 0)
flag_data <- rbind(flag_data, Serbia)

## +Slovakia
Slovakia <- data.frame(country = "Slovakia", 
                     red = 1,
                     green = 0,
                     blue = 1,
                     gold = 0,
                     white = 1,
                     black = 0,
                     orange = 0,
                     domcolor = "blue",
                     language = 5,
                     circles = 0,
                     sunstars = 0,
                     icons = 1,
                     animates = 0,                    
                     crosses = 1)
flag_data <- rbind(flag_data, Slovakia)

## +Slovenia
Slovenia <- data.frame(country = "Slovenia", 
                       red = 1,
                       green = 0,
                       blue = 1,
                       gold = 1,
                       white = 1,
                       black = 0,
                       orange = 0,
                       domcolor = "blue",
                       language = 5,
                       circles = 0,
                       sunstars = 1,
                       icons = 1,
                       animates = 0,                    
                       crosses = 0)
flag_data <- rbind(flag_data, Slovenia)

## +Moldova
Moldova <- data.frame(country = "Moldova", 
                       red = 1,
                       green = 0,
                       blue = 1,
                       gold = 1,
                       white = 0,
                       black = 0,
                       orange = 0,
                       domcolor = "blue",
                       language = 5,
                       circles = 0,
                       sunstars = 1,
                       icons = 1,
                       animates = 1,                    
                       crosses = 1)
flag_data <- rbind(flag_data, Moldova)

## +East Timor
Timor <- data.frame(country = "East Timor", 
                      red = 1,
                      green = 0,
                      blue = 0,
                      gold = 1,
                      white = 1,
                      black = 1,
                      orange = 0,
                      domcolor = "red",
                      language = 10,
                      circles = 0,
                      sunstars = 1,
                      icons = 1,
                      animates = 0,                    
                      crosses = 0)
flag_data <- rbind(flag_data, Timor)

## +Eritrea
Eritrea <- data.frame(country = "Eritrea", 
                    red = 1,
                    green = 1,
                    blue = 1,
                    gold = 1,
                    white = 0,
                    black = 0,
                    orange = 0,
                    domcolor = "green",
                    language = 8,
                    circles = 0,
                    sunstars = 1,
                    icons = 1,
                    animates = 0,                    
                    crosses = 0)
flag_data <- rbind(flag_data, Eritrea)

## +Marshall Islands
Marshalls <- data.frame(country = "Marshall Islands", 
                      red = 0,
                      green = 0,
                      blue = 1,
                      gold = 0,
                      white = 1,
                      black = 0,
                      orange = 1,
                      domcolor = "blue",
                      language = 10,
                      circles = 0,
                      sunstars = 1,
                      icons = 1,
                      animates = 0,                    
                      crosses = 0)
flag_data <- rbind(flag_data, Marshalls)

## +Montenegro
Montenegro <- data.frame(country = "Montenegro", 
                        red = 1,
                        green = 1,
                        blue = 1,
                        gold = 1,
                        white = 1,
                        black = 0,
                        orange = 0,
                        domcolor = "red",
                        language = 5,
                        circles = 0,
                        sunstars =0,
                        icons = 1,
                        animates = 1,                    
                        crosses = 0)
flag_data <- rbind(flag_data, Montenegro)

## +Namibia
Namibia <- data.frame(country = "Namibia", 
                         red = 1,
                         green = 1,
                         blue = 1,
                         gold = 0,
                         white = 1,
                         black = 0,
                         orange = 0,
                         domcolor = "green",
                         language = 6,
                         circles = 0,
                         sunstars =0,
                         icons = 1,
                         animates = 1,                    
                         crosses = 0)
flag_data <- rbind(flag_data, Namibia)

## +Palau
Palau <- data.frame(country = "Palau", 
                      red = 0,
                      green = 0,
                      blue = 1,
                      gold = 1,
                      white = 0,
                      black = 0,
                      orange = 0,
                      domcolor = "blue",
                      language = 1,
                      circles = 1,
                      sunstars =0,
                      icons = 0,
                      animates = 0,                    
                      crosses = 0)
flag_data <- rbind(flag_data, Palau)

## +Western Sahara
Sahara <- data.frame(country = "Western Sahara", 
                    red = 1,
                    green = 1,
                    blue = 0,
                    gold = 0,
                    white = 1,
                    black = 1,
                    orange = 0,
                    domcolor = "black",
                    language = 3,
                    circles = 0,
                    sunstars =1,
                    icons = 1,
                    animates = 0,                    
                    crosses = 0)
flag_data <- rbind(flag_data, Sahara)

Kongo <- data.frame(country = "Congo Republic", 
                    red = 1,
                    green = 1,
                    blue = 0,
                    gold = 1,
                    white = 0,
                    black = 0,
                    orange = 0,
                    domcolor = "green",
                    language = 10,
                    circles = 0,
                    sunstars =1,
                    icons = 1,
                    animates = 0,                    
                    crosses = 0)
flag_data <- rbind(flag_data, Kongo)

# remove single country datasets
rm(Russia)
rm(Belarus)
rm(Kazakhstan)
rm(Ukraine)
rm(Estonia)
rm(Latvia)
rm(Lithuania)
rm(Armenia)
rm(Azerbaijan)
rm(Georgia)
rm(Kyrgyzstan)
rm(Tajikistan)
rm(Turkmenistan)
rm(Uzbekistan)
rm(Bosnia)
rm(Croatia)
rm(Czech)
rm(Serbia)
rm(Slovakia)
rm(Slovenia)
rm(Moldova)
rm(Timor)
rm(Eritrea)
rm(Marshalls)
rm(Montenegro)
rm(Namibia)
rm(Palau)
rm(Sahara)
rm(Kongo)

# Add language factor #########################################################
languages <- c("English",
              "Spanish",
              "French",
              "German",
              "Slavic",
              "Indo-European",
              "Chinese",
              "Arabic",
              "Japanese/Turkish/Finnish/Magyar",
              "Others")
flag_data <- mutate(flag_data, language=factor(language, labels=languages))
flag_data <- mutate(flag_data, count = 1)


# Add flags url ###############################################################
data(Population)
flag_pics <- select(Population, Country, Flag)
flag_pics <- arrange(flag_pics, Country)
flag_pics$Country[45] <- "DR Congo"
flag_pics$Country[141] <- "Congo Republic"
flag_pics[196,1] <- "Greenland"
flag_pics[196,2] <- "<img src=//upload.wikimedia.org/wikipedia/commons/thumb/0/09/Flag_of_Greenland.svg/22px-Flag_of_Greenland.svg.png>"


flag_data <- merge(flag_data, flag_pics,
                   by.x="country",
                   by.y="Country",
                   all.x=FALSE) #FALSE - only with flag pics


# for debbugging names
# c <- flag_pics$Country
# sapply(c, function(x){
#     if(x %in% flag_data$country) {
#         
#     } else {print(x)}
#     
# })

# Add predominant color index for worldmap ####################################

colors <- flag_data$domcolor
colors <- sapply(colors, function(x) {
    switch(x,
           black = 1,
           blue = 2,
           brown = 3,
           gold = 4,
           green = 5,
           orange = 6,
           red = 7,
           white = 8
           )
})
flag_data <- mutate(flag_data, colindex = colors)


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
            ds <- arrange(ds, country)
            
            # Print with out NA function
            cutNA <- function(x) {
                if(!is.na(x)) {
                    cat(x)
                } else {
                    cat("&nbsp &nbsp &nbsp")
                }
            } 

            # Elastic print to 3 columns
            if (nrow(ds)>0) {
                cat("<TABLE BORDER=0 WIDTH=100%>")
                for (i in seq(1, nrow(ds), by=3)) {
                    cat("<TR>")
                    cat("<TD width=33%>");cutNA(ds[i,17]);cat(" ");cutNA(ds[i,1]);cat("</TD>")
                    cat("<TD width=33%>");cutNA(ds[i+1,17]);cat(" ");cutNA(ds[i+1,1]);cat("</TD>")
                    cat("<TD width=33%>");cutNA(ds[i+2,17]);cat(" ");cutNA(ds[i+2,1]);cat("</TD>")
                    cat("</TR>")    
                }
                cat("</TABLE>")
            }

    })
    
    # The Number of selected countries 1
    output$n1 <- renderPrint({
            
            ds <- selector()
            cat(paste("Countries:", nrow(ds)))
            
    })
        
    # The Number of selected flags 2
    output$n2 <- renderPrint({
        
        ds <- selector()
        cat(paste("Flags:", nrow(ds)))
        
    })
    
    
    # The worldmap ############################################################
    output$map <- renderGvis({
            
            ds <- selector()

            
            color_json_vector <- "{values:[1,2,3,4,5,6,7,8], 
                                colors:['black', 'blue',
                                'brown', 'gold',
                                'green', 'orange', 'red', 'white']}"
            
            gvisGeoChart(ds, locationvar = "country",
                         colorvar = "colindex",
                         options = list(
                         colorAxis = color_json_vector     
                             ))

    })
    
    # The language statistic
    output$lang <- renderPlot({
        
            ds <- selector()
            
            if (nrow(ds) > 0) {
                
                # Awkward code to display on the chart full list of languages
                # even if probability == 0
                lng_prob <- sapply(languages, function(x){
                    mean(grepl(x, ds$language))
                })

                lng_ds <- cbind.data.frame(languages, lng_prob)
                
                # Barplot
                g <- ggplot(lng_ds, aes(x=languages, y=lng_prob))
                g <- g + geom_bar(fill = "skyblue",
                                  colour = "black", stat="identity")
                g <- g + coord_flip()
                g <- g + labs(x = "")
                g <- g + labs(y = "probability")
                g
            
            }
        
    })
    
})