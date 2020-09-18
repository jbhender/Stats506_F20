#!usr/bin/env bash

# 79: -------------------------------------------------------------------------  
# Example showing the `while read` loop pattern for shell scripting
#
# Run the example using: `bash ./ex_while_read.sh`
#
# Author(s): James Henderson
# Updated: September 18, 2020
# 79: -------------------------------------------------------------------------

## version 1
echo Version 1
while read col1 col2
do
    echo $col1 $col2
done < nhanes_files.txt

## version 2
echo Version 2
while read col1 col2; do
    echo $col1 $col2
done < nhanes_files.txt


# 79: -------------------------------------------------------------------------
