#!usr/bin/env bash

# 79: -------------------------------------------------------------------------         
# Run all files and build solution to Problem Set 4
#
# For question 2, it is assumed the datasets:
#  * `nhanes_demo.csv` (from PS1),
#  * `demo_ps3.dta` (from PS3), and
#  * `ohxden_ps3.dta` (from PS3) 
# are all in the local directory. 
#
# Build the solution using:
#  bash ps4_make.sh
#
# On GreatLakes, first:
#    module load sas
#    module load python3.6-anaconda/5.2.0 # to enable xml2 package to load
#    module load R/4.0.2
#
# Author: James Henderson (jbhender@umich.edu)
# Updated: Nov 24, 2020
# 79: -------------------------------------------------------------------------

## prepare Q1 data
bash ./0-ps4_q1_data.sh 
sas 1-ps4_q1_prepdata.sas 

## q1
sas 2-ps4_q1_analysis.sas

## q2
sas 3-ps4_q2.sas

## build the solution 
Rscript -e "rmarkdown::render('./PS4_Solution.Rmd')"

# 79: -------------------------------------------------------------------------
