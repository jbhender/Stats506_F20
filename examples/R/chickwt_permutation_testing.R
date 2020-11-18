# Chick Weight Permutation Testing Example
# 
# Author: James Henderson
# Updated: November 16, 2020
# 79: -------------------------------------------------------------------------

# libraries: ------------------------------------------------------------------
library(tidyverse); library(data.table)

# Visualize the data: ---------------------------------------------------------
data(chickwts)
str(chickwts)
with(chickwts, boxplot(weight ~ feed, las = 1), 'Chick Weight Data')

# Parametric analysis: --------------------------------------------------------
anova(lm(weight ~ feed, data = chickwts))

# function to compute the ANOVA F statistic: ----------------------------------
compute_F = function(dt, response, group){
  # compute the ANOVA F statistic
  # dt - a data.table with columns response and group
  # response - the name of a (numeric) column in dt, used as the response (DV)
  # group - the name of a column in dt, used as the grouping factor (IV)

  stopifnot( c(response, group) %in% names(dt) )
  stopifnot( "data.table" %in% class(dt) )
  
  # compute the grand mean
  gm = dt[, mean(.SD[[response]])]
  
  # compute group means
  sum_stat = 
    dt[, .(N = .N, xbar = mean(.SD[[1]]), v = var(.SD[[1]])), 
       c(group), .SDcols = response]
  
  # compute the mean squares
  ms_group = sum_stat[, sum( (xbar - gm)^2 * N / (.N - 1) )]
  ms_error = sum_stat[,  sum(v * (N - 1))] / (nrow(dt) - nrow(sum_stat))
  
  # F
  ms_group / ms_error
}

## testing
dt_chickwts = as.data.table(chickwts)
head(dt_chickwts)
compute_F(dt_chickwts, 'weight', 'feed')

# function to permute and test: -----------------------------------------------
permute_F = function(dt, response = 'weight', group = 'feed'){
  dt[, group := .SD[[..group]][sample(.N, replace = FALSE)]]
  compute_F(dt, response, 'group')
}
permute_F(dt_chickwts, 'weight', 'feed')

# the permutation test: -------------------------------------------------------
F_obs = compute_F(dt_chickwts, 'weight', 'feed')

nperm = 1e3
perm_F = sapply(1:nperm, function(i) permute_F(dt_chickwts, 'weight', 'feed') )
hist(perm_F, las = 1, main = 'F statistics for permuted Chick Weight Data', 
     col = rgb(0, 0, 1, .5), xlab = 'F')

p = {1 + sum(F_obs <= perm_F)} / {1 + length(perm_F)}
pval_str = sprintf('p = %5.3f', p)
cat(pval_str)
1 / sqrt(1e5)

