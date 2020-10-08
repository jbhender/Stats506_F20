## Stats 506, F20
## table examples, 1
## 
## This script explores options for creating tables of estimates in
## order to emphasize specific comparisons. 
##
## The RData file recs2015_temps.RData contains a tibble `temps` with estimates
## of residential wintertime temperatures organized by:
##  1. census division
##  2. rurality
##  3. time of day (daytime/at home, daytime/away, night)
##
## Author: James Henderson, jbhender@umich.edu
## Updated: October 8, 2020
# 79: -------------------------------------------------------------------------

# libraries: ------------------------------------------------------------------
library(tidyverse)

# directories: ----------------------------------------------------------------
path = '~/github/Stats506_F20/examples/data'
foo = load(sprintf('%s/recs2015_temps.RData', path)) #temps

# format for table presentation: ----------------------------------------------
temps = temps %>%
  mutate( 
    avg_temp = sprintf('%4.1f (%4.1f, %4.1f)', est, lwr, upr),
    avg_temp2 = 
      sprintf('<div> %4.1f </div> <div>(%4.1f, %4.1f)</div>', est, lwr, upr)
  )

# option 1: -------------------------------------------------------------------
# columns - urban
# rows - type, division

table1 = temps %>%
  pivot_wider(
    id_cols = c('type', 'division'),
    names_from = 'urban',
    values_from = 'avg_temp', 
  ) %>%
  arrange(type, division) %>%
  rename(`Census Division` = division) %>%
  select(!type) %>%
  knitr::kable(format = 'html') %>%
  kableExtra::kable_styling('striped', full_width = TRUE) 

## group by type
types = with(temps, unique(type))
type_labels = 
  c(gone = 'Daytime temperature with no one at home.',
    home = 'Daytime temperature with someone at home.',
    night = 'Nightime temperature.'
  )
types = types[order(types)]
n_divs = with(temps, length(unique(division)))

for ( i in 1:length(types) ) {
  table1 = 
    kableExtra::group_rows(
      table1, 
      group_label = type_labels[types[i]],
      start_row = (i - 1) * n_divs + 1,
      end_row = i * n_divs
    ) 
}
table1 

# option 2: -------------------------------------------------------------------
# columns - urban
# rows - division, type

table2 = temps %>%
  pivot_wider(
    id_cols = c('division', 'type'),
    names_from = 'urban',
    values_from = 'avg_temp', 
  ) %>%
  arrange(division, type) %>%
  rename(`Temperature Type` = type) %>%
  mutate( division = '') 
col_names = names(table2)
col_names[1] = '  '
table2 = table2 %>%
  knitr::kable(format = 'html', col.names = col_names) %>%
  kableExtra::kable_styling('striped', full_width = TRUE) 

## group by division
divs = with(temps, unique(division))
n_types = with(temps, length(unique(type)))

for ( i in 1:length(divs) ) {
  table2 = 
    kableExtra::group_rows(
      table2, 
      group_label = divs[i],
      start_row = (i - 1) * n_types + 1,
      end_row = i * n_types
    ) 
}

# option 3: -------------------------------------------------------------------
# columns - urban, type
# rows - division

table3 = temps %>%
  pivot_wider(
    id_cols = c('division'),
    names_from = c('urban', 'type'),
    values_from = 'avg_temp2', 
  )

col_names = c('Census Division', rep(types, 3))
urban_levels = with(temps, levels(urban))
top_header = c(1, 3, 3, 3)
names(top_header) = c(' ', urban_levels)

table3 = table3 %>%
  knitr::kable(
    format = 'html', col.names = col_names, escape = FALSE, align = 'c'
  ) %>%
  kableExtra::kable_styling('striped', full_width = TRUE) %>%
  kableExtra::add_header_above(header = top_header)

# option 4: -------------------------------------------------------------------
# columns - type
# rows - division, urban
# sortable

table4 = temps %>%
  pivot_wider(id_cols = c('division', 'urban'),
              names_from = 'type',
              values_from = 'avg_temp', 
  ) %>%
  arrange(division, urban) %>%
  rename(`Census Division` = division, `Urban Type` = urban) %>%
  DT::datatable()

