#!usr/bin/env bash

# 79: -------------------------------------------------------------------------         
# Run all files and build problem set 1 solution
#
# Author: James Henderson (jbhender@umich.edu)
# Updated: Sep 24, 2020
# 79: -------------------------------------------------------------------------

# question 1: -----------------------------------------------------------------
bash ./ps1_q1_ohxden.sh
bash ./ps1_q1_demo.sh

# write up (includes question 2): ---------------------------------------------
Rscript -e "rmarkdown::render('./PS1_Solution.Rmd')"

# 79: -------------------------------------------------------------------------
