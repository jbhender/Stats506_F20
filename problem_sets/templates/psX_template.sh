#!/bin/env bash

# Stats 506, Fall 2020
#
# Include a title and descriptive header with the same elements described
# in `psX_template.R`
#
# Author(s): James Henderson
# Updated: September 13, 2020
# 79: -------------------------------------------------------------------------

# download data for the problem set if needed: --------------------------------
file="" 
url=""

## download only if the file doesn't exist
if [ ! -f "$file" ]; then
  wget $url
fi

# run supporting scripts if they aren't sourced in the Rmarkdown file: --------
# Rscript ./1-psX_q3_clean_data.R

# render the problem set markdown file: ---------------------------------------
Rscript -e 'rmarkdown::render("psX_template.Rmd")'

## or for documents to be created with "spin"
Rscript -e 'knitr::spin("psX_spin_template.R", knit = FALSE)'
Rscript -e 'rmarkdown::render("psX_spin_template.Rmd")' && \
    rm psX_spin_template.Rmd

# 79: -------------------------------------------------------------------------
