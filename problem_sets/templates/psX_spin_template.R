#' ---
#' title: "Stats 506, F20, Problem Set X"
#' author: "Your Name, email@umich.edu"
#' date: "`r format.Date(Sys.Date(), '%B %d, %Y')`"
#' output: pdf_document
#' ---

#+ setup, include=FALSE
# 79: --------------------------------------------------------------------------
#! We generally don't need to see the code in the results document.
knitr::opts_chunk$set(echo = FALSE)
#! Make sure all chunks have a label. This one is labelled 'setup'.

#' ## Question 1
#' Comments like `#'` indicate to treat the remaining text as markdown rather
#' than a standard R comment. Labels and options for R chunks follow `#+`. 
#'
#' ### Part A
#' Use a first level header for each question.
#' Use lower level headers for thematic parts.
#'
#' ### Part B
#' Use numbered lists for specific parts of each question:
#' 
#'  i. Response to first item in part B.
#'     Maybe reference supporting tables and graphs.
#'  i. Response to second item in part B.
#'
#' \pagebreak
#'
#' ## Question 2: Including Plots
#' 
#' Please start each question on a new page in pdf documents.

#+ q2_pressure_plot, echo=FALSE, fig.height=4, fig.cap=cap
# Create a plot for the `pressure` data as in the default Rmd file: -----------
cap = paste0(
 "**Figure 1.** *Title.* All figures and tables should be numbered, titled ",
 "and have a descriptive caption."
)
plot(pressure)

#'
#' \pagebreak
#'
#' ## Question 3: Other considerations.
#' Start your answer to each question by describing the supporting files used to
#' produce the results to follow.
#' The three files below are used to answer question 3:
#'  - `0-psX_q3_data.sh` downloads the data
#'  - `1-psX_q3_clean.R` does some data cleaning and processing
#'  - `2-psX_q3_analysis.R` contains the statistical analysis.


#+ q3_prep, include=FALSE
# Run the supporting scripts so this document to focus on reporting: ----------
#source('./1-psX_q3_clean.R')
#source('./2-psX_q3_analysis.R')







