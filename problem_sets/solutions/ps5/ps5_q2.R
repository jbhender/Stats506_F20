# PS5, Q2
#
# Use cross-validation to compare the out-of-sample prediction accuracy
# of three models predicting presence of a permanent tooth as a function
# of age. 
# 
# Updated: December 4, 2020
# Author: James Henderson, PhD
# 79: -------------------------------------------------------------------------

# libraries: ------------------------------------------------------------------
library(tidyverse); library(data.table); library(mgcv)
library(parallel); library(doParallel)

# set to TRUE to re-run even if output already exists: ------------------------
force_rerun = FALSE

## predictions in cleaned dataset
prediction_file = 'ps5_q2_ohx_long.RData'

## cross entropy results
loss_file = 'ps5_q2_cross_entropy_loss.RData'

# limit on number of cores for parallel computing: ----------------------------
max_cores = 4 

# data: -----------------------------------------------------------------------
path = './'

## demographics
demo_file = sprintf('%s/nhanes_demo.csv', path)
demo = fread(demo_file)

## tooth count / dentition
ohx_file = sprintf('%s/nhanes_ohxden.csv', path)
ohx = fread(ohx_file)

# clean demo: -----------------------------------------------------------------
demo_clean = demo[, .(id = SEQN, age = RIDAGEYR, gender = factor(RIAGENDR))]

# merge and clean: ------------------------------------------------------------

## long format ohx
ohx_long = 
  melt(ohx[OHDDESTS == 1], 
       id.vars = c('SEQN', 'OHDDESTS'),
       measure.vars = grep('[0-9]TC$', names(ohx), value = TRUE)
  )
setnames(ohx_long, c('id', 'ohx_status', 'tooth', 'tooth_status'))

## merge
ohx_long = merge(ohx_long, demo_clean, by = 'id')

## flag permanent tooth present
ohx_long[, perm_tooth := tooth_status == 2]

# b, identify folds: ----------------------------------------------------------

## by cohort
last_id = c(5e3, 71916, 83731, 93702, 102956)
ohx_long[, cohort := as.numeric(cut(id, last_id))] 

folds = ohx_long[, unique(cohort)]

# c, models: ------------------------------------------------------------------

## Version 1: joint model with 
#  - single spline for age for all teeth
#  - tooth specific intercepts
#  - random subject effects

### fit models to each fold
v1_file = 'ps5_q2_v1_bam.RData'
rerun_v1 = force_rerun || !file.exists(v1_file)

if (rerun_v1) {
  v1_list = mclapply(folds,
                     function(fold) {
                       bam(perm_tooth ~ tooth + s(age, bs = 'cs') + s(id, bs = 're'), 
                           data = ohx_long[cohort != fold],
                           family =  binomial(link = 'logit')
                       )
                     },
                     mc.cores = min(max_cores, length(folds))
  )

  names(v1_list) = paste(folds)
  save(v1_list, file = v1_file)  

} else {
  load(v1_file)
} # end if (rerun), v1

### make predictions
for (fold in folds) {
  ohx_long[fold == fold, 
           yhat_v1 := predict(v1_list[[paste(fold)]], .SD, type = 'response')]
}

## Version 2: joint model with 
##  - distinct splines for all ages
##  - tooth specific intercepts
##  - random subject effects
v2_file = 'ps5_q2_v2_bam.RData'
rerun_v2 = force_rerun || !file.exists(v2_file)

if (rerun_v2) {
  v2_list = mclapply(folds, 
   function(fold) {
     bam(
       perm_tooth ~ tooth + s(age, bs = 'cs', by = tooth) + s(id, bs = 're'), 
       data = ohx_long[cohort != fold],
       family = binomial(link = 'logit')
     )
   },
   mc.cores = min(max_cores, length(folds))
  )

  names(v2_list) = folds
  save(v2_list, file = v2_file)

} else {
  load(v2_file)
}
### make predictions
for (fold in folds) {
  ohx_long[fold == fold, 
           yhat_v2 := predict(v2_list[[paste(fold)]], .SD, type = 'response')]
}

## Version 3: separate models for each tooth
teeth = ohx_long[, unique(tooth)]

v3_file = 'ps5_q2_v3_bam.RData'
rerun_v3 = force_rerun || !file.exists(v3_file)

if (rerun_v3) {
  
  # setup dedicated cluster
  cl = makeCluster(max_cores) 
  registerDoParallel(cl)
  
  # use nested foreach loops
  v3_list = 
    foreach(fold=folds, .packages=c('data.table', 'mgcv')) %:%
    foreach(tth=teeth) %dopar% {
      bam(
        perm_tooth ~ s(age, bs = 'cs'),
        data = ohx_long[cohort != fold & tooth == tth],
        family = binomial(link = 'logit')
      )
    }
  
  # shutdown cluster
  stopCluster(cl)
  
  # name results for easier indexing
  names(v3_list) = folds
  for (fold in folds) {
    names(v3_list[[paste(fold)]]) = teeth
  }
  
  save(v3_list, file = v3_file)

} else {
  load(v3_file)
}  

### make predictions
for (fold in folds) {
  for (tth in teeth) {
    mod = v3_list[[paste(fold)]][[paste(tth)]]
    ohx_long[cohort == fold & tooth == tth, 
             yhat_v3 := predict(mod, .SD, type = 'response')]
  }
}

# save ohx_long with predictions: ---------------------------------------------
save(ohx_long, file = prediction_file)

# d, compute cross entropy loss: ----------------------------------------------
cross_entropy_loss = function(y, yhat) {
  # compute the cross entropy loss
  # y - observed binary results
  # yhat - predicted probability
  -mean( y * log(yhat) + (1 - y) * log(1 - yhat) )
}

loss = 
  ohx_long[, 
             lapply(.SD, cross_entropy_loss, y = ohx_long[['perm_tooth']]),
             .SDcols = grep('^yhat_v', names(ohx_long)) 
  ]

loss_by_cohort =
  ohx_long[, lapply(.SD, 
                      cross_entropy_loss, 
                      y = ohx_long[cohort == .BY[[1]][1], perm_tooth]),
             by = cohort,
             .SDcols = grep('^yhat_v', names(ohx_long)) 
  ]

loss_by_tooth =
  ohx_long[, lapply(.SD, 
                      cross_entropy_loss, 
                      y = ohx_long[tooth == .BY[[1]][1], perm_tooth]),
             by = tooth,
             .SDcols = grep('^yhat_v', names(ohx_long)) 
  ]

save(loss, loss_by_cohort, loss_by_tooth, file = loss_file)

# 79: -------------------------------------------------------------------------
