#! /bin/env -bash

# -----------------------------------------------------------------------------  
# Download data for the SAS examples using `wget`.
#
# Author: James Henderson
# Updated: October 17, 2020
#79: --------------------------------------------------------------------------


# RECS 2009 microdata 

## csv
file0=recs2009_public.csv
if [ ! -f ./data/$file0 ]; then
    wget https://www.eia.gov/consumption/residential/data/2009/csv/$file0
    mv $file0 ./data/
fi

## sas format
file1=recs2009_public_v4.zip
file1a=recs2009_public_v4.sas7bdat
if [ ! -f ./data/$file1 ]; then
    wget https://www.eia.gov/consumption/residential/data/2009/sas/$file1
    unzip $file1
    mv $file1a ./data/
fi

# NOAA daily weather data
file2=ghcnd-stations.txt
if [ ! -f ./data/$file2 ]; then
    wget ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/$file2
    mv $file2 ./data/
fi

#79: --------------------------------------------------------------------------  
