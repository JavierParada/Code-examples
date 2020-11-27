
## Motivation
The main motivation behind this shiny app is to make it easier to locate data on organized violence and armed conflict from the Uppsala Conflict Data Program (UCDP).

## Data:
The [Uppsala Conflict Data Program (UCDP)](https://ucdp.uu.se/) is a data collection program on organized violence, based at Uppsala University in Sweden. The UCDP is a leading provider of data on organized violence and armed conflict, and it is the oldest ongoing data collection project for civil war, with a history of almost 40 years. UCDP data are systematically collected and have global coverage, comparability across cases and countries, and long time series. Data are updated annually and are publicly available, free of charge. Furthermore, preliminary data on events of organized violence in Africa is released on a monthly basis.

The original data is available as a file called "ged201.RData". The raw data file and my shiny code are both available on my github.

### UCDP Georeferenced Event Dataset (GED) Global version 20.1
This dataset is UCDP's most disaggregated dataset, covering individual events of organized violence (phenomena of lethal violence occurring at a given time and place). These events are sufficiently fine-grained to be geo-coded down to the level of individual villages, with temporal durations disaggregated to single, individual days.

## Data limitation
One of the limitations of this application is that some observations in the raw data have incomplete data on location. There are close to X NA values for latitude and longitude. Then, when we create the shiny application we will ignore these points. 

## Help:
Please do not hesitate to <a href = "mailto: fparadagomezurqu@worldbank.org">contact me</a> if you have any comments or suggestions.
