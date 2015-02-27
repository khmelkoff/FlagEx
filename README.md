

# xFlags
Developing Data Products Course, The Shiny Application

**xFlags** - an application that allows you to find the country on the details of its flag and look at the distribution of languages for a given set of features.

Select one of the tabs:

- **Worldmap** - Countries on the world map  
- **Countries** - List of countries  
- **Languages** - language distribution in the chart  

Choose a combination of details of the flag: The dominant color and/or some colors of the flag and/or other features (stars, circles, icons). 
Information on the tabs changes every time you change your selection.

The application uses the data of 1986, revised in a reproducible manner.
Fixed 31 country name, removed “not actual” countries (USSR, DDR, Czechoslovakia etc), added new countries (e.g. Kazakhstan, Russia)

Used R-packages:
```Shiny, dplyr, googleVis, ggplot2```