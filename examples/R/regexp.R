# Regular Expressions
#
# This script contains code from the section 
#  "Regular Expressions" from the 
#  "Strings and Regular Expressions" notes.
#
# Author: James Henderson
# Updated: Nov 2, 2020
# 79: -------------------------------------------------------------------------

# libraries: ------------------------------------------------------------------
library(stringr) # stringr is in the tidyverse

# Regular Expressions: --------------------------------------------------------
# *Regular expressions* ("regexp" or "regex") are a way to describe patterns in 
# strings, often in an abstract way. There is a common regexp vocabulary 
# though some details differ between implementations and standards. 
# The basic idea is illustrated in the examples below using the fruit data
# from the `stringr` library.

## find all two word fruits by searching for a space
fruit[grep(" ", fruit)]

## find all fruits with an 'a' anywhere in the word
fruit[grep("a", fruit)]

## find all fruits starting with 'a'
fruit[grep("^a", fruit)]

## find all fruits ending with 'a'
fruit[grep("a$", fruit)]

## find all fruits starting with a vowel
fruit[grep("^[aeiou]", fruit)]

## find all fruits with two consecutive vowels
fruit[grep("[aeiou]{2}", fruit)]

## find all fruits ending with two consecutive consonants other than r
fruit[grep("[^aeiour]{2}$", fruit)]

# wild-cards and quantifiers: -------------------------------------------------
# In the example below we use `.` to match any (single) character. This behaves
# much like `?` in a Linux file name. We can ask for multiple matches by
# appending `*` if we want 0 or more matches and `+` if we want at
# least 1 match.

## find all fruits with two consecutive vowels twice, separated by a single
## consonant
fruit[grep("[aeiou]{2}.[aeiou]{2}", fruit)]

## find all fruits with two consecutive vowels twice, separated by one or
## more consonants
fruit[grep("[aeiou]{2}.+[aeiou]{2}", fruit)]

## find all fruits with exactly three consecutive consonants in the middle of
## two vowels
fruit[grep("[aeiou][^aeiou ]{3}[aeiou]", fruit)]
str_view(fruit, "[aeiou][^aeiou ]{3}[aeiou]") # most useful in RStudio

# escaping meta-characters to match the literal character: --------------------
# To match an actual period (or other meta-character) we need to escape with a
# backslash. Thus, we use the regular expression `\\.` The double backslash is
# need specifically b/c we are passing the regular expression as a string in R.
c(fruit, "umich.edu")[grep('\\.', c(fruit, "umich.edu"))]

# grouping and back reference: ------------------------------------------------
# Matched values can be grouped using parentheses `()` and referred back to 
# in the order they appear using a back reference `\\1`. 

## find all fruits with a repeated letter
fruit[grep("(.)\\1", fruit)]

## find all fruits with a repeated letter but exclude double r
fruit[grep("([^r])\\1", fruit)]

## find all fruits that end with a repeated letter
fruit[grep("(.)\\1$", fruit)]
