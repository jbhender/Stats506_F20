#!/bin/env bash
# Stats 506, Fall 2020
# <1> Update the header with your information. 
# This script serves as a template for Part 1 of 
# the shell scripting activity for week 1. 
#
# Author(s): James Henderson
# Updated: September 13, 2020
# 79: -------------------------------------------------------------------------

# preliminary, so you know you've run the script
message="Running week1_part1.sh ... "
echo $message

# a - download data if not present
#<2> Uncomment the lines below and fill in the file name and url. 
#file="" 
#url=""

## if the file doesn't exist
if [ ! -f "$file" ]; then
    ##<3> Use wget to download the file
    echo "You will get an error if the body of an if statement is empty."
fi

# b - extract header row and output to a file with one name per line
new_file="recs_names.txt"

## delete new_file if it is already present
#? Can you spot and correct the error here?
if [ -f "$file" ]; then
  rm "$new_file"
fi

# <4> Write your one liner below.  Consider testing in multiple steps. 

# c - get column numbers for DOEID and the BRR weights
# as a comma separated string to pass to `cut`
# <5> write your one liner below
# < $new_file grep -n -E "DOEID|BRR" | cut -f? -d? | paste ???

# <6> uncomment the next three lines and copy the one liner above
#cols=$(
# copy your one-liner from <5> here
#)

# Uncomment the line below for testing and development:
# echo $cols

# d - cut out the appropriate columns and save as recs_brrweights.csv
# <7> write your one-liner below


# 79: -------------------------------------------------------------------------
