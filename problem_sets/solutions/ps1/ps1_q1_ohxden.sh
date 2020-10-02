#!usr/bin/env bash

# 79: -------------------------------------------------------------------------         
# Problem Set 1, Question 1
#
# Download and combine NHANES data on Oral Health
# Dentition Exams and Demographics from the 2011-2012
# to 2017-2018 cycles.
#
# This is the pattern for the urls, the years and final letters are
# listed in `ps1_nhanes_files.txt`:
#  > https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/OHXDEN_I.XPT
#
# For the dentition exams, we extract a subset of relevant
# variables.
#
# Author: James Henderson (jbhender@umich.edu)
# Updated: Sep 24, 2020
# 79: -------------------------------------------------------------------------

# input parameters: -----------------------------------------------------------
new_file='nhanes_ohxden.csv'
col_regex='SEQN|OHDDESTS|OHX[0-9]*TC|OHX[0-9]*CTC'

# download and prepare dentition data: ----------------------------------------

## loop over cohorts to download and convert to csv
while read cohort id; do
    
    ### Define variables
    url=https://wwwn.cdc.gov/Nchs/Nhanes/$cohort/OHXDEN_$id.XPT
    xpt_file=OHXDEN_$id.XPT
    csv_file=OHXDEN_$id.csv

    ### Don't redownload if csv file is present
    if [ ! -f $csv_file ]; then
	
	### Download data if not present
	if [ ! -f $xpt_file ]; then
	    wget $url
	fi

	### Convert files to csv using R
	read="haven::read_xpt('$xpt_file')"
	write="data.table::fwrite($read, file = '$csv_file')"
	Rscript -e "$write" # Double quotes allow expansion

    fi

done < ps1_nhanes_files.txt

# Extract columns and append files: -------------------------------------------
if [ -f $new_file ]; then
    echo File $new_file already exists, move or delete.
else
    ## get the headers 
    while read cohort id; do
	bash ./cutnames.sh OHXDEN_$id.csv $col_regex |
            head -n1 >> $new_file.tmp
    done < ps1_nhanes_files.txt

    ## verify the columns all match in the right order 
    if [ $(< $new_file.tmp uniq | wc -l ) != 1 ]; then
	echo Matching columns are not identical: see $new_file.tmp.
    else
	echo Columns match, appending ...
	## headers for $new_file and cleanup
	< $new_file.tmp head -n1 > $new_file
	rm $new_file.tmp
    
	## add the data
	while read cohort id; do
	    bash ./cutnames.sh OHXDEN_$id.csv $col_regex |
		tail -n+2 >> $new_file
	done < ps1_nhanes_files.txt
    fi
fi

# 79: -------------------------------------------------------------------------
