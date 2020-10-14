# Stats 506, F20
# Problem Set 2
# Clean and prepare data in support of solution for question 1
#
# This script uses the 2009 and 2015 RECS microdata and codebooks downloaded
#  by `0-ps2_q1_data.sh` to create minimal data sets: 
#    recs09, recs15 - id, census division, rurality, and tv variables 
#    w09, w15 - "balanced repeated replicate" weights for each id, long format
#
# Author: James Henderson (jbhender@umich.edu)
# Updated: Oct 8, 2020
# 79: -------------------------------------------------------------------------

# libraries: ------------------------------------------------------------------
library(tidyverse)

# data directory: -------------------------------------------------------------
path = './'

# functions: ------------------------------------------------------------------
decode_recs = function(x, varname, codes = codes) {
  # apply factor labels to variables using the codebook "codes"
  # Inputs: 
  #   x - input vector to be changed to factor
  #   varname - the name of the 'variable' in `codes`
  #   codes - a codebook of factor levels and labels
  # Output: x converted to a factor with levels given in codes
  
  with(filter(codes, variable == varname),
       factor(x, levels = levels[[1]], labels = labels[[1]])
  )
}

# codebooks: ------------------------------------------------------------------
## 2009 code book
cb09_file = sprintf('%s/recs2009_public_codebook.xlsx', path)
cb09 = readxl::read_xlsx(cb09_file, skip = 1) %>% 
  select(1:4) %>%
  filter(!is.na(`Variable Name`)) %>%
  transmute(
    variable = `Variable Name`,
    levels = 
      stringr::str_split(`Response Codes and Labels`, pattern = '\\r\\n'),
    labels =  stringr::str_split(`...4`, pattern = '\\r\\n')
  )

## 2015 code book
cb15_file = sprintf('%s/codebook_publicv4.xlsx', path)
cb15 = readxl::read_xlsx(cb15_file, skip = 3) %>% 
  select(c(1, 4:6)) %>%
  transmute(
    variable = `SAS Variable Name`,
    levels = 
      stringr::str_split(`...5`, pattern = '\\r\\n'),
    labels =  stringr::str_split(`Final Response Set`, pattern = '\\r\\n')
  )

# data: -----------------------------------------------------------------------

## variables of interest from either data set
recs_vars = 
  c('DOEID', 'NWEIGHT', 
    'DIVISION', 'UR', 'UATYP10', 'TVCOLOR', 'TVTYPE1', 'TVTYPE')

## 2009
recs09_file = sprintf('%s/recs2009_public.csv', path)
recs09 = read_delim(recs09_file, delim = ',') %>%
  select( any_of(recs_vars) )

recs09 = recs09 %>%
  transmute(
    id = as.numeric(DOEID),
    w = NWEIGHT,
    division = decode_recs(DIVISION, 'DIVISION', cb09),
    rurality = decode_recs(UR, 'UR', cb09),
    tv_n = TVCOLOR,
    tv_type = decode_recs(TVTYPE1, 'TVTYPE1', cb09)
  ) 

w09_file = sprintf('%s/recs2009_public_repweights.csv', path)
w09 = read_delim(w09_file, delim = ',') %>%
  rename(id = DOEID) %>%
  select(!"NWEIGHT")

## 2015
recs15_file = sprintf('%s/recs2015_public_v4.csv', path)
recs15 = read_delim(recs15_file, delim = ',') %>%
  select( any_of(recs_vars), starts_with('BRR') )

w15 = recs15 %>% select(id = DOEID, starts_with('BRR'))

recs15 = recs15 %>%
  transmute(
    id = DOEID,
    w = NWEIGHT,
    division = decode_recs(DIVISION, 'DIVISION', cb15),
    rurality = decode_recs(UATYP10, 'UATYP10', cb15),
    rurality = factor(ifelse( grepl('Urban', rurality), 'Urban', 'Rural')),
    tv_n = TVCOLOR,
    tv_type = decode_recs(TVTYPE1, 'TVTYPE1', cb15),
    tv_type = ifelse( tv_type %in% c('LCD', 'LED'), 
                      as.character(tv_type),
                      str_to_title(tv_type) )
  ) 

# match division labels: ------------------------------------------------------
recs09 = recs09 %>%
  mutate(
    division = str_split_fixed(division, '[ ]{1,2}Census| Sub-', n = 2)[, 1],
    division = factor(division, levels = levels(recs15[['division']])),
    tv_type = ifelse( tv_type %in% c('LCD', 'LED'), 
                      as.character(tv_type),
                      str_to_title(tv_type) )
    )
stopifnot( all(!is.na(recs09[['division']])) )

# make replicate weights to compute std error using group_by / summarize: -----
w09 = w09 %>% 
  pivot_longer(
    cols = starts_with('brr'), 
    names_to = 'repl', 
    names_prefix = 'brr_weight_',
    values_to = 'w'
  )

w15 = w15 %>% 
  pivot_longer(
    cols = starts_with('BRR'), 
    names_to = 'repl', 
    names_prefix = 'BRRRWT',
    values_to = 'w'
  )

# save data prepped for ps2_q1: -----------------------------------------------
file = sprintf('%s/ps2_q1.RData', path)
#lapply(list(recs09, w09, recs15, w15), pryr::object_size) # check sizes
#sum( sapply(list(recs09, w09, recs15, w15), pryr::object_size) ) / 1e6

save(recs09, w09, recs15, w15, file = file) #~85 MB

# 79: -------------------------------------------------------------------------


