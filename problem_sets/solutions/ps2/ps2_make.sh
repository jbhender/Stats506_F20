#!usr/bin/env bash

# 79: -------------------------------------------------------------------------         
# Run all files and build solution to Problem Set 2
# 
# Build the solution using:
#  bash ps2_make.sh
#
# Author: James Henderson (jbhender@umich.edu)
# Updated: Oct 14, 2020
# 79: -------------------------------------------------------------------------

## download data
bash 0-ps2_q1_data.sh 

## clean data
Rscript 1-ps2_q1_prep_data.R

## build the solution 
# this sources: 2-ps2_q1_analysis.R
Rscript -e "rmarkdown::render('./PS2_solution.Rmd')"


# 79: -------------------------------------------------------------------------
