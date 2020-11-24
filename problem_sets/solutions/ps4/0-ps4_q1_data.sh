#!usr/bin/env bash

# 79: -------------------------------------------------------------------------         
# Problem Set 4, Question 1
#
# Download 2009 and 2015 RECS microdata and 2009 replicate weights in SAS
# format for PS4, Q1. 
#
# Author: James Henderson (jbhender@umich.edu)
# Updated: Nov 4, 2020
# 79: -------------------------------------------------------------------------

# input parameters: -----------------------------------------------------------
base_url=https://www.eia.gov/consumption/residential/data

# download microdata: ---------------------------------------------------------

## 2009 RECS
if [ ! -f recs2009_public_v4.sas7bdat ]; then
    z=recs2009_public_v4.zip
    wget $base_url/2009/sas/$z
    unzip $z
    rm $z
fi

## 2009 RECS replicate weights
if [ ! -f recs2009_public_repweights.sas7bdat ]; then
    z=recs2009_public_repweights_sas7bdat.zip
    wget $base_url/2009/sas/$z
    unzip $z
    rm $z
fi

## 2015 RECS (includes replicate weights)
if [ ! -f recs2015_public_v4.sas7bdat ]; then
    z=recs2015_public_v4.zip
    wget $base_url/2015/sas/$z
    unzip $z
    rm $z    
fi

# 79: -------------------------------------------------------------------------
