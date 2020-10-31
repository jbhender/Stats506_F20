#!usr/bin/env bash

# 79: -------------------------------------------------------------------------         
# Run all files and build solution to Problem Set 3
#
# It is assumed the datasets `nhanes_demo.csv` and `nhanes_ohxden.csv` are
# in the local directory. 
#
# Build the solution using:
#  bash ps3_make.sh
#
# Author: James Henderson (jbhender@umich.edu)
# Updated: Oct 30, 2020
# 79: -------------------------------------------------------------------------

## stata executable
stata_exe=stata-se

## prepare data
$stata_exe -b ./ps3_prep_data.do

## q1
$stata_exe -b ./ps3_q1.do

## q2
$stata_exe -b ./ps3_q2.do

## q3
$stata_exe -b ./ps3_q3.do

## build the solution 
Rscript -e "rmarkdown::render('./PS3_solution.Rmd')"

# 79: -------------------------------------------------------------------------
