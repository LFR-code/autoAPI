# vDatUpdate.R

# Author: B Doherty, Landmark Fisheries Research
# Last Edit: Jan 28, 2021

# Details:
# 1) Run API data request from Marine Traffic and save .csv
# 2) Merges API data with historical API data requests

library(dplyr)
library(readr)
library(httr)

vDatUpdate <- function()
{
  apiDat <- GET("https://services.marinetraffic.com/api/exportvessels/v:8/b4e695ebc89e35240878ced885d1b5cb61f7fea8/timespan:10/protocol:csv")

  if(apiDat$status==200)
  {  

    lastDat <- content(apiDat,type='text/csv') %>%
        as.data.frame()

    lastDat$TIMESTAMP <- as.POSIXct(lastDat$TIMESTAMP, tz='UTC')
    # lastDat$TIMESTAMP <- as.POSIXct(as.numeric(as.character(lastDat$TIMESTAMP)), origin="1970-01-01", tz='UTC')

    filename <- paste('vDat',round(as.numeric(Sys.time()),0),'.csv', sep='') 
    write.csv(lastDat, file.path('apiData',filename), row.names=FALSE)

    vDat    <- read.csv('apiData/vDat.csv') 

    vDat$TIMESTAMP <- as.POSIXct(vDat$TIMESTAMP, tz='UTC') 
    vDat <- rbind(vDat, lastDat)

    write.csv(vDat, 'apiData/vDat.csv',row.names=FALSE)

  }  else {
      filename <- paste('vDat',round(as.numeric(Sys.time()),0),'.txt', sep='') 
      writeLines(content(apiDat), 'vDatTest.txt')
  }
    

  return(apiDat)  
}

apiDat <- vDatUpdate()
