#!usr/bin/env bash

# 79: -------------------------------------------------------------------------         
# Run all files and build solution to Problem Set 5
#
# For question 2, it is assumed the datasets:
#  * `nhanes_demo.csv` (from PS1), and
#  * `nhanes_ohxden.csv` (from PS1)
# are all in the local directory. 
#
# Build the solution using:
#  bash ps5_make.sh
#
# On GreatLakes, first:
#    module load python3.6-anaconda/5.2.0 # to enable xml2 package to load
#    module load R/4.0.2
#
# Author: James Henderson (jbhender@umich.edu)
# Updated: December 9, 2020
# 79: -------------------------------------------------------------------------


## 2015 RECS (includes replicate weights)
base_url=https://www.eia.gov/consumption/residential/data
if [ ! -f recs2015_public_v4.csv ]; then
    wget $base_url/2015/csv/recs2015_public_v4.csv
fi

## q1
# ps5_q1.R ## is sourced from the Rmd file

## q2
Rscript ps5_q2.R

## build the solution 
Rscript -e "rmarkdown::render('./PS5_Solution.Rmd')"

# 79: -------------------------------------------------------------------------
