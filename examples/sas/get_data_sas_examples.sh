#! /bin/env -bash

# -----------------------------------------------------------------------------  
# Download data for the SAS examples using `wget`.
#
# Author: James Henderson
# Updated: October 17, 2020
#79: --------------------------------------------------------------------------


# NOAA daily weather data
file1=ghcnd-stations.txt
if [ ! -f .data/$file1 ]; then
    wget ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/$file1
    mv $file1 ./data/
fi

#79: --------------------------------------------------------------------------  
