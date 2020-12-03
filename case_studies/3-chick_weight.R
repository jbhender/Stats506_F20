## ChickWeight case study (bootstrap)
## Stats 506, Fall 2020
##
## Use the bootstrap to compute 95% confidence intervals for
## the median final weight within each diet. Do the same for the 
## median final weight relative to the initial birth weight.
## All analyses are conditional on survival to week 21.
##
## This case study uses data.table. For a version using the tidyverse, please
## see the Stats506_F19 GitHub repo.
##
## Data: datasets::Chickweight
##
## Updated: November 16, 2020
## Author: James Henderson

# libraries: ------------------------------------------------------------------
library(tidyverse); library(data.table)

# ChickWeight data: -----------------------------------------------------------
cw = as.data.table(ChickWeight)
str(cw, give.attr = FALSE)

# Visualize the data: ---------------------------------------------------------
cw[Time == max(Time)] %>%
  ggplot( aes( x = Diet, y = weight, fill = Diet) ) + 
  geom_boxplot( alpha = .5) + 
  theme_bw() + 
  geom_point( aes(color = Diet), position = position_jitter(width = .1) ) +
  ylab('Chick weight at 21 weeks (grams)')

# Count cases missing times: --------------------------------------------------
cw[, .N, keyby = .(Diet, Time)] %>% 
  .[, .( nmiss = max(N) - min(N) ), Diet]

# Compare starting and ending weights: ----------------------------------------
merge(
  cw[Time == min(Time), .(Diet, Chick, start = weight)],
  cw[Time == max(Time), .(Chick, end = weight)],
  by = 'Chick'
) %>%
  ggplot(aes( x = start, y = end, color = Diet) ) +
  geom_point(alpha = .5) + 
  facet_wrap(~Diet) + 
  theme_bw()

# Compute relative weight: ----------------------------------------------------
cw[, relweight := weight / weight[Time == 0], Chick]

# Interactive computation the data.table way: ---------------------------------

# Ensure we pick only week 21, not earlier max time if missing data.
cw[Time == max(Time), .(.N, median = median(weight)), Diet]

# Progress towards functional version: ----------------------------------------

# What if we needed to compute the median for multiple variables?
med_cols = c("weight", "relweight")
cw[Time == max(Time), c(.N, lapply(.SD, median)), Diet, .SDcols = med_cols]

# Function to compute median by group for specific columns
df_group_median = function(df, cols, group = '') {
  df[, lapply(.SD, median), c(group), .SDcols = cols]
}

# Test new function
df_group_median( cw[Time ==  max(Time)], cols = 'weight', group = 'Diet')
df_group_median( 
  cw[Time ==  max(Time)],
  cols = c('weight', 'relweight'),
  group = 'Diet'
)

# Function to compute a sub-sample: -------------------------------------------
cw_final = cw[Time == max(Time)]

# To illustrate the idea, we will want to retain the group sizes. 
cw_final[, bweight := weight[sample(.N, replace = TRUE)], Diet]

merge(
  cw_final[, .N, keyby = .(Diet, weight)],
  cw_final[, .(boot_n = .N), keyby = .(Diet, weight = bweight)],
  all.x = TRUE
)

df_group_boot = function(df, cols, group = '') {
  # prep list of boot functions
  boot = function(x) sample(x, replace = TRUE)
  
  # bootstrap sample
  df[, .SD[boot(.N)], group, .SDcols = cols]
}

# Test these two functions together: ------------------------------------------ 
cw_final %>% 
  df_group_boot(., 'weight', group = 'Diet') %>%
  df_group_median(., 'weight', group = 'Diet')

# Here's a version that does both sampling and median computation in one step.
df_boot_median = function(df, cols, group = '') {
  # prep list of boot functions
  boot = function(x) sample(x, replace = TRUE)
  
  # bootstrap sample
  df[, lapply(.SD[boot(.N)], median), group, .SDcols = cols]

}
# Test the above function
median_est = df_boot_median(cw_final, c('weight', 'relweight'), 'Diet')

# Create 1000 bootstrap samples.
#! How could we vectorize this?
boot_samples = list()
for (i in 1:1e3) {
  boot_samples[[i]] = 
    df_boot_median(cw_final, c('weight', 'relweight'), 'Diet') 
  boot_samples[[i]][, b := ..i] 
}
class(boot_samples[[2]])
boot_samples = rbindlist(boot_samples)

boot_ci = boot_samples[, 
 c(.(bound = c('lwr', 'upr')), lapply(.SD, quantile, probs = c(0.025, 0.975))),
 Diet, 
 .SDcols = c('weight', 'relweight')
]

## reshape to long and then to wide with bounds as columns
boot_ci_long = melt(boot_ci, 
     id.vars = c('Diet', 'bound'),
     measure.vars = c('weight', 'relweight'),
     variable.name =  'var'
     ) %>%
dcast(Diet + var ~ bound, value.var = 'value')

## point estimates
cw_median = 
  df_group_median(cw_final, c('weight', 'relweight'), group = 'Diet') %>%
  melt(
    id.vars = 'Diet',
    measure.vars = c('weight', 'relweight'),
    variable.name =  'var',
    value.name = 'median'
  )

## join these two together
boot_ci_long = merge(cw_median, boot_ci_long, by = c('Diet', 'var'))

# Plot medians and associated 95% confidence intervals for each group/var: ----
boot_ci_long %>%
  ggplot( aes(x = Diet, y = median) ) +
  geom_point( pch = 15 ) +
  geom_errorbar( aes(ymin = lwr, ymax = upr) ) +
  facet_grid(var ~ ., scales = 'free_y' ) + 
  theme_bw() +  
  ylab(
  'Week 21 weight [lower: relative to birth weight; upper: actual weight (gm)]'
  )
