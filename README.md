*Dear Peers,  
this repository has been created in ten days before the course started  
since I tried "Dev Data Products" for free in the last week of February.*

# xFlags - The simple flag expert system


**xFlags** - an application that allows you to find the country on the details of its flag and look at the distribution of languages for a given set of features.

Select one of the tabs:

- **Worldmap** - Countries on the world map  
- **Countries** - List of countries with flags  
- **Languages** - language distribution in the chart  

Choose a combination of details of the flag: The predominant color and/or some colors of the flag and/or other features (stars, circles, icons). 
Information on the tabs changes every time you change your selection.

The application uses the data of 1986, revised in a reproducible manner.
Fixed 31 country name, removed “not actual” countries (USSR, DDR, Czechoslovakia etc), added 29 new names (e.g. Kazakhstan, Russia)

Used R-packages:
```Shiny, dplyr, googleVis, ggplot2```