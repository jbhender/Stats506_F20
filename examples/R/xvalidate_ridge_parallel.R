# Cross-validation in ridge regression 
# Stats 506, Fall 2020
# 
# Author: James Henderson
# Updated: November 29, 2020
# 79: -------------------------------------------------------------------------

# libraries: ------------------------------------------------------------------
library(tidyverse)
library(parallel)
library(doParallel) # foreach, iterators
library(glmnet)

# Function to compute the RMSE: -----------------------------------------------
rmse = function(y, yhat) {
  sqrt( mean( {y - yhat}^2 ) )
}

# Simulation parameters: ------------------------------------------------------
p = 100
n = 1.2 * p
s = 4

# Generate a covariance matrix: -----------------------------------------------
sigma = rbeta( choose(p, 2), .3, .3) * {runif(choose(p, 2)) <= .1}

## Up-weight the diagonal to ensure we have a positive definite matrix.
Sigma = p * diag(p)/2

## Ensure it is symmetric, then re-scale to give variance one.
Sigma[lower.tri(Sigma)] = sigma
Sigma = {Sigma + t(Sigma)} / p

## The Cholesky decomposition will allow us to generate data from N(0, Sigma).
R = chol(Sigma)

# Here are some "true" coefficients for data generation: ----------------------
beta = runif(p, 0, 1)

# Generate training data: -----------------------------------------------------
X_train = matrix(rnorm(n * p), n, p) %*% R
Y_train = X_train %*% matrix(beta, ncol = 1) + s * rnorm(n)

# Generate test data: ---------------------------------------------------------

## Here we use a "50-50" split, but "80-20" is more common in practice.
X_test = matrix(rnorm(n * p), n, p) %*% R
Y_test = X_test %*% matrix(beta) + s * rnorm(n)

# This fits a ridge regression choosing "beta-hat" to minimize
#  beta_hat = argmin_b .5 * ||Y - Xb||^2  + lambda * ||b||^2
#
# It actually selects a sequence of lambda's for the fit, how is outside our
# scope.  
fit1 = glmnet(X_train, Y_train, alpha = 0)

# Sequence of lambdas
lambda = fit1$lambda

res = Y_train - coef(fit1)[1] - X_train %*% coef(fit1)[2:{1 + ncol(X_test)}, ]
tibble(
  training_rmse = sqrt( colMeans(res^2)), 
  lambda = lambda
)  %>%
  ggplot(aes(x = lambda, y = training_rmse)) + 
  geom_line() + 
  theme_bw() +
  scale_x_log10()

# But, we want to choose lambda before using the test data: -------------------
# So we use cross validation to select "lambda" 

# Number of folds
n_folds = 10 #nrow(X_train)

# Our data is arbitrarily ordered
folds = 0:{nrow(X_train) - 1} %% n_folds

# Cross validation with sequential computations: ------------------------------

## sequential, uniform compute times
tm1 = proc.time()
leave_out_rmse = list()
for (fold in unique(folds) ) {
    Sys.sleep(2) # just to illustrate a point
    #Sys.sleep( wait_times[fold + 1] ) # wait an unknown number of seconds
    fit = glmnet(X_train[folds != fold, ], Y_train[folds != fold, ], 
                 alpha = 0, lambda = lambda)    
    leave_out_rmse[[fold + 1]] = 
     sqrt( colMeans( {Y_train[fold == fold, ] - coef(fit)[1] - 
           X_train[fold == fold, ] %*% coef(fit)[2:{1 + ncol(X_train)}, ] }^2 
    ) )

}
tm2 = proc.time()
sequential_uniform = tm2 - tm1

## sequential, skewed compute times
### random set of wait times for illustrating a point about parallel comps
wait_times = rpois( length(unique(folds)), 2)
sum(wait_times)

tm1 = proc.time()
leave_out_rmse = list()
for ( fold in unique(folds) ) {
  Sys.sleep( wait_times[fold + 1] ) # wait an unknown number of seconds
  fit = glmnet(X_train[folds != fold, ], Y_train[folds != fold, ], 
               alpha = 0, lambda = lambda)    
  leave_out_rmse[[fold + 1]] = 
    sqrt( colMeans( {Y_train[fold == fold, ] - coef(fit)[1] - 
        X_train[fold == fold, ] %*% coef(fit)[2:{1 + ncol(X_train)}, ] }^2 
    ) )
}
tm2 = proc.time()
sequential_poisson = tm2 - tm1

# Cross validation with parallel computations (mclapply): ---------------------

## function for the body of the for loop
do_fold = function(fold, wait_times) {
  Sys.sleep(wait_times[fold + 1]) # wait an "unknown" number of seconds
  fit = glmnet(X_train[folds != fold, ], Y_train[folds != fold, ], 
               alpha = 0, lambda = lambda)    
  
  sqrt( colMeans( {Y_train[ fold == fold, ] - coef(fit)[1] - 
      X_train[fold == fold, ] %*% coef(fit)[2:{1 + ncol(X_train)}, ] }^2 ) )
}


## Uniform times ##############################################################

### with pre-scheduling, split examples into blocks
tm1 = proc.time()
leave_out_rmse_mcl = 
  mclapply(unique(folds), 
           do_fold, 
           wait_times = rep(2, n_folds),
           mc.preschedule = TRUE, 
           mc.cores = 2)
tm2 = proc.time()
mclapply_ps_uniform = tm2 - tm1

### without pre-scheduling 
tm1 = proc.time()
leave_out_rmse_mcl = 
  mclapply(unique(folds), 
           do_fold, 
           wait_times = rep(2, n_folds),
           mc.preschedule = FALSE, 
           mc.cores = 2)
tm2 = proc.time()
mclapply_no_ps_uniform = tm2 - tm1

## Poisson times ##############################################################

### with pre-scheduling, split examples into blocks
tm1 = proc.time()
leave_out_rmse_mcl = 
  mclapply(unique(folds), 
           do_fold, 
           wait_times = wait_times,
           mc.preschedule = TRUE, 
           mc.cores = 2)
tm2 = proc.time()
mclapply_ps_poisson = tm2 - tm1

#### with pre-scheduling, split examples into blocks
cbind(
  core1 = wait_times[1:10 %% 2 == 1],
  core2 = wait_times[1:10 %% 2 == 0]
)
sum(sum(wait_times[1:10 %% 2 == 1]))
sum(sum(wait_times[1:10 %% 2 == 0]))

### without pre-scheduling 
tm1 = proc.time()
leave_out_rmse_mcl = 
  mclapply(unique(folds), 
           do_fold, 
           wait_times = wait_times,
           mc.preschedule = FALSE, 
           mc.cores = 2)
tm2 = proc.time()
mclapply_no_ps_poisson = tm2 - tm1

## "bad luck" for pre-scheduling with Poisson times ###########################
ord = order(wait_times)
m = n_folds %/% 2
bad_luck = as.numeric(
  rbind(
    wait_times[ord[1:m]], 
    wait_times[ord[{m + 1}:n_folds]]
  )
)

cbind(
  core1 = bad_luck[1:10 %% 2 == 1],
  core2 = bad_luck[1:10 %% 2 == 0]
)
sum(bad_luck[1:10 %% 2 == 1])
sum(bad_luck[1:10 %% 2 == 0])

tm1 = proc.time()
leave_out_rmse_mcl = 
  mclapply(unique(folds), 
           do_fold, 
           wait_times = bad_luck,
           mc.preschedule = TRUE, 
           mc.cores = 2)
tm2 = proc.time()
mclapply_ps_bad_luck = tm2 - tm1

## bad luck w/o pre-scheduling
tm1 = proc.time()
leave_out_rmse_mcl = 
  mclapply(unique(folds), 
           do_fold, 
           wait_times = bad_luck,
           mc.preschedule = FALSE, 
           mc.cores = 2)
tm2 = proc.time()
mclapply_no_ps_bad_luck = tm2 - tm1

# the `foreach` approach: -----------------------------------------------------

## set up a named cluster
cl = makeCluster(2, setup_timeout = 0.5) # work around for bug on Mac
registerDoParallel(cl)

## parallel computations using the %dopar% operator
tm1 = proc.time()
leave_out_rmse_foreach = 
  foreach(fold = unique(folds), .packages = 'glmnet') %dopar% {
    do_fold(fold, wait_times = rep(2, n_folds))
  }
tm2 = proc.time()
foreach_uniform =  tm2 - tm1

## parallel computations using the %dopar% operator, random times
tm1 = proc.time()
leave_out_rmse_foreach = 
  foreach(fold = unique(folds), .packages = 'glmnet') %dopar% {
    do_fold(fold, wait_times = wait_times)
  }
tm2 = proc.time()
foreach_poisson =  tm2 - tm1

## parallel computations using the %dopar% operator, "bad_luck" times
tm1 = proc.time()
leave_out_rmse_foreach = 
  foreach(fold = unique(folds), .packages = 'glmnet') %dopar% {
    do_fold(fold, wait_times = bad_luck)
  }
tm2 = proc.time()
foreach_bad_luck =  tm2 - tm1

## shutdown cluster
stopCluster(cl)

# compare times for different scenarios: --------------------------------------

## uniform times
sequential_uniform
mclapply_ps_uniform
mclapply_no_ps_uniform
foreach_uniform

## random Poisson times
sequential_poisson
mclapply_ps_poisson
mclapply_no_ps_poisson
foreach_poisson

## "bad luck" times
mclapply_ps_bad_luck
mclapply_no_ps_bad_luck
foreach_bad_luck

# continue with the cross-validation example: ---------------------------------

## Form a n_folds x length(lambda) matrix of estimated RMSE and 
## then average within each column. 
leave_out_rmse = colMeans( do.call('rbind', leave_out_rmse) )
#leave_out_rmse_foreach = colMeans( do.call('rbind', leave_out_rmse_foreach) )
plot(log(leave_out_rmse_foreach) ~ log(lambda))

# Estimate the hyperparameter "lambda": ---------------------------------------
lambda_hat = lambda[which.min(leave_out_rmse)]

# Get the prediction for the selected lambda: ---------------------------------
rmse(Y_test, predict(fit1, X_test)[, which.min(leave_out_rmse)])

# Compare to OLS: -------------------------------------------------------------
beta_ols = coef( lm(Y_train ~ X_train) )
rmse(Y_test, beta_ols[1] + X_test %*% beta_ols[-1])

