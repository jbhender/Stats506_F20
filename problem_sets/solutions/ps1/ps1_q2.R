# Stats 506, F20
# Problem Set 1
# Solution for Question 2
#
# Author: James Henderson (jbhender@umich.edu)
# Updated: September 26, 2020
# 79: -------------------------------------------------------------------------

# example data: ---------------------------------------------------------------
if ( FALSE ) {
  # run for interactive testing but not when sourced
  path = './'
  file = sprintf('%s/isolet_results.csv', path)
  isolet = read.table(file, sep = ',', header = TRUE)
}

# helper function: ------------------------------------------------------------
.perf_counts = function(yhat, y) {
  # counts true and false positive and negatives for each unique value of yhat
  # Inputs:
  #  yhat - a numeric predictor for y
  #     y - binary vector of true values being predicted, the larger value
  #         is assumed to be the target label for `y >= tau`
  # Outputs: a data.frame with columns, y-hat, tp, fp, tn, fn counting the
  #  number of true positives, false positives, true negatives, and false
  #  negatives for each unique value of y-hat
  
  # unique values
  tab = table(-yhat, y)

  # total samples and total positives
  n = length(y)
  pos = sum(tab[, 2])

  # results
  tp = unname( cumsum(tab[, 2]) )
  fp = unname( cumsum(tab[, 1]) )
  fn = pos - tp
  tn = n - pos - fp
  #stopifnot( all( unique( tp + fp + fn + tn) == n )  )
  
  # returned data.frame
  data.frame(yhat = sort(unique(yhat), decreasing = TRUE), tp, fp, tn, fn)
}
#with(isolet, .perf_counts(yhat, y))

# part a, function to compute sens, spec, AUC-ROC, and plot ROC: --------------
perf_roc = function(yhat, y, plot = c('none', 'base', 'ggplot2')) {
  # compute area under the ROC curve and optionally produce a plot
  # Inputs:
  #  yhat - a numeric predictor for y
  #     y - binary vector of true values being predicted, the larger value
  #         is assumed to be the target label for `y >= tau`
  #  plot - type of plot, if any, to produce as a side-effect, defaults
  #         to 'none' for no plot in which case the output list below is
  #         always returned.  When plot = 'base' or 'ggplot2' the list below
  #
  # Outputs: 
  #  A named list with the elements below, returned invisibly when not plotted.
  #  detail  - a data.frame with columns, `yhat`, `tp`, `fp`, `tn`, `fn` 
  #            counting the number of true positives, false positives, 
  #            true negatives, and false negatives for each unique value
  #            of `yhat` and the corresponding sensitivity and specificity.
  #  auc_roc - the area under the ROC curve
  #  
  # make sure y is binary and y and yhat are of equal length
  stopifnot( length(unique(y)) == 2 )
  stopifnot( length(y) == length(yhat) )
  
  # resolve plotting argument
  plot_type = match.arg(plot, c('none', 'base', 'ggplot2'))
  
  # counts
  df = .perf_counts(yhat, y)
  
  # sensitivity and specificity
  df[['sens']] = with(df, tp / {tp + fn})
  df[['spec']] = with(df, tn / {tn + fp})
  
  # area under the ROC curve 
  auc_roc = with(df,
      .5 * sum(diff(1 - spec) * {sens[-1] + sens[-length(sens)]})
  )
  
  out = list(detail = df, auc_roc = auc_roc)
  
  # plot the curves when requested

  ## none, always return
  if ( plot_type == 'none' ) {
    return(out)
  }
  
  ## base, create plot
  if ( plot_type == 'base' ) {
    plot(sens ~ I(1 - spec), 
         data = df, 
         type = 'l',
         las = 1,
         xlab = '1 - specificity',
         ylab = 'sensitivity'
    )
    segments(0, 0, 1, 1, lty = 'dashed', col = 'grey')
    legend('bottomright', c(sprintf('AUC ROC = %5.3f', auc_roc)), bty = 'n')
  }
  
  ## ggplot2
  if ( plot_type == 'ggplot2' ) {
    requireNamespace('ggplot2', quietly = FALSE)
    p = ggplot(df, aes(x = 1 - spec, y = sens)) +
      geom_line() +
      geom_segment( aes(x = 0, y = 0, xend = 1, yend = 1), 
                    col = 'grey', lty = 'dashed') + 
      geom_label(data = NULL, 
                 aes(x = 1, y = 0, hjust = 'right',
                     label = sprintf('AUC ROC = %5.3f', auc_roc)),
                  fill = 'grey') + 
      xlab('1 - specificity') + 
      ylab('sensitivity') +
      theme_bw()
    print(p)
  }
  
  ## return invisibly (only when assigned)
  invisible(out)
}
#roc = with(isolet, perf_roc(yhat, y))

# part b, function to compute precision, recall, AUC-PR, and plot PRC: --------
perf_pr = function(yhat, y, plot = c('none', 'base', 'ggplot2')) {
  # compute area under the precision recall curve and optionally produce a plot
  # Inputs:
  #  yhat - a numeric predictor for y
  #     y - binary vector of true values being predicted, the larger value
  #         is assumed to be the target label for `y >= tau`
  #  plot - type of plot, if any, to produce as a side-effect, defaults
  #         to 'none' for no plot in which case the output list below is
  #         always returned.  When plot = 'base' or 'ggplot2' the list below
  #
  # Outputs: 
  #  A named list with the elements below, returned invisibly when not plotted.
  #  detail  - a data.frame with columns, `yhat`, `tp`, `fp`, `tn`, `fn` 
  #            counting the number of true positives, false positives, 
  #            true negatives, and false negatives for each unique value
  #            of `yhat` and the corresponding precision and recall values.
  #  auc_pr - the area under the precision-recall curve

  # make sure y is binary and y and yhat are of equal length
  stopifnot( length(unique(y)) == 2 )
  stopifnot( length(y) == length(yhat) )
  
  # resolve plotting argument
  plot_type = match.arg(plot, c('none', 'base', 'ggplot2'))
  
  # counts
  df = .perf_counts(yhat, y)
  
  # sensitivity and specificity
  df[['recall']] = with(df, tp / {tp + fn})
  df[['precision']] = with(df, tp / {tp + fp})
  
  # area under the ROC curve 
  auc_pr = with(df,
                .5 * sum(diff(recall) * {precision[-1] + precision[-nrow(df)]})
  )
  
  out = list(detail = df, auc_pr = auc_pr)
  
  # plot the curves when requested
  
  ## none, always return
  if ( plot_type == 'none' ) {
    return(out)
  }
  
  ## base, create plot
  if ( plot_type == 'base' ) {
    plot(precision ~ recall, 
         data = df, 
         type = 'l',
         las = 1,
         xlab = 'recall',
         ylab = 'precision',
         ylim = c(0, 1)
    )
    legend('bottomleft', c(sprintf('AUC-PR = %5.3f', auc_pr)), bty = 'n')
  }
  
  ## ggplot2
  if ( plot_type == 'ggplot2' ) {
    requireNamespace('ggplot2', quietly = FALSE)
    p = ggplot(df, aes(x = recall, y = precision)) +
      geom_line() +
      geom_label(data = NULL, 
                 aes(x = 0, y = 0, hjust = 'left',
                     label = sprintf('AUC-PR = %5.3f', auc_pr)),
                 fill = 'grey') + 
      xlab('recall') + 
      ylab('precision') +
      theme_bw()
    print(p)
  }
  
  ## return invisibly (only when assigned)
  invisible(out)
}
#pr = with(isolet, perf_pr(yhat, y))

# 79: -------------------------------------------------------------------------


