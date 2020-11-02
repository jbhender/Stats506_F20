# Working with Strings in R
#
# This script contains code from the section 
#  "Working with Strings in R" from the 
#  "Strings and Regular Expressions" notes.
#
# Author: James Henderson
# Updated: Nov 2, 2020
# 79: -------------------------------------------------------------------------

# libraries: ------------------------------------------------------------------
library(stringr) # stringr is in the tidyverse

# string basics: --------------------------------------------------------------
# In R, you create strings of type `character` using either single or double 
# quotes. There is no difference (in R) between the two.
string1 = "This is a string."
string2 = 'This is a string.'
all.equal(string1, string2)
typeof(string1)

# You can mix single and double quotes when you want to include
# one or the other within your string.
string_single = "These are sometimes called 'scare quotes'."
print(string_single)

string_double = 'Quoth the Raven, "Nevermore."'
print(string_double)
cat(string_double,'\n')

# You can also include quotes within a string by escaping them:
string_double = "Quoth the Raven, \"Nevermore.\""
print(string_double)
cat(string_double,'\n')

# Observe the difference between `print()` and `cat()` in terms of how the 
# escaped characters are handled. Be aware also that because backslash plays 
# this special role as an escape character, it itself needs to be escaped:
backslash = "This is a backslash '\\', this is not '\ '."
writeLines(backslash)

# files as templates: ---------------------------------------------------------

# Similar to `cat()` is the function `writeLines()` used above. The latter is 
# more syntactic when writing to a file and has the advantage of adding a line
# between components of a vector. Below is an example.
some_file = c('Line 1', 'Line 2')
writeLines(some_file)

## compare to cat
cat(some_file)

# You should also make note of `readLines()` for reading the text in a file.
# It is helpful to realize that `readLines()` and `writeLines()` are inverse
# to one another. 

# The two can be used in conjunction with a template and a find-and-replace
# function (see below) to create a series of related `.R` or other files 
# for automating a series of related tasks. 
template = readLines('./template.sh')
writeLines(template)
for ( i in 1:3 ) {
  new_file = sprintf('./template-%i.sh', i)
  writeLines(
    stringr::str_replace_all(template, 'my_file', paste(i) ), 
    con = new_file 
  )
  cat('Wrote ', new_file, '.\n', sep = '')
}

# concatenating strings: ------------------------------------------------------
#The functions `paste` and `stringr::str_c` are both used to join strings 
# together.

# Observe the difference between the `sep` and `collapse` arguments in `paste`.
length(LETTERS)
paste(LETTERS, collapse = "")
paste(1:26, LETTERS, sep = ': ')
paste(1:26, LETTERS, sep = ': ', collapse = '\n ')

# Below we see that `str_c` behaves similarly.
all.equal(str_c(LETTERS, collapse = ""), paste(LETTERS, collapse = "") )
all.equal(str_c(1:26, LETTERS, sep = ': '), paste(1:26, LETTERS, sep = ': ') )
all.equal(str_c(1:26, LETTERS, sep = ': ', collapse = '\n '), 
          paste(1:26, LETTERS, sep = ': ', collapse = '\n ') 
)

# However, these functions differ in the treatment of missing values (`NA`).
paste(1:3, c(1, NA, 3), sep = ':', collapse = ', ')
str_c(1:3, c(1, NA, 3), sep = ':', collapse = ', ')
str_c(1:3, str_replace_na(c(1, NA, 3)), sep = ":", collapse = ', ')

# string length: --------------------------------------------------------------
# Recall that `length` returns the length of a vector. To get the length of a
# string use `nchar` or `str_length`.
length(paste(LETTERS, collapse = "") )
nchar(paste(LETTERS, collapse = "") )
str_length(paste(LETTERS, collapse = "") )


#### substrings

The following functions extract sub-strings at given positions.
```{r str11}
substr('Strings',  3, 7)
str_sub('Strings', 1, 6)
```

The function `stringr::str_sub` supports negative indexing.
```{r str12}
sprintf('base: %s, stringr: %s', 
        substr('Strings', -5, -1), 
        str_sub('Strings', -5, -1)
)
```

#### finding matches

The example below uses the vector `fruit` from the `stringr` package.

The base function `grep` returns the indices of all strings within a vector 
that contain the requested pattern. The `grepl` function behaves in the same way 
but returns a logical vector of the same length as the input `x`.

```{r str13}
head(fruit)
grep('fruit', fruit)
which(grepl('fruit', fruit) )
head(grepl('fruit', fruit) )
grepl('fruit', fruit)[grep('fruit', fruit)]
```

These functions are vectorized over the input but not the pattern.

```{r str14}
grep(c('fruit', 'berry'), fruit)
sapply(c('fruit', 'berry'), grep, x = fruit)
```

The `match` function is vectorized over the input, but returns only the first
match  and requires exact matching.

```{r str15}
match('berry', fruit)
match(c('apple', 'pear'), c(fruit,fruit) )
```

The corresponding `stringr` functions are vectorized over both pattern and
input, but the vectorization uses broadcasting so be careful. Pay attention to
the order that the string and pattern are supplied in as it is the reverse of
the base functions.

```{r str16}
ind_fruit = which(str_detect(fruit, 'fruit') )
ind_berry = which(str_detect(fruit, 'berry') )

ind_either = which(str_detect(fruit, c('fruit','berry') ) )
setdiff(union(ind_fruit, ind_berry), ind_either )

# Below we demonstrate the broadcasting pattern
ind_odd = seq(1, length(fruit), 2)
ind_even = seq(2, length(fruit), 2)

odd_fruit = ind_odd[ str_detect(fruit[ind_odd], 'fruit') ]
even_berry = ind_even[ str_detect(ruit[ind_even], 'berry') ]
setdiff(union(odd_fruit, even_berry), ind_either )
```

The vectorization in this case doesn't help us to avoid the `lapply` pattern we
used with `grep`.

```{r str17}
sapply(c('fruit', 'berry'), function(x) which(str_detect(fruit, x) ) )
```

However, `str_locate` is vectorized using an "OR" operator.

```{r str18}
ind_fruit = str_locate(fruit, 'fruit')
ind_berry = str_locate(fruit, 'berry')

ind_either = str_locate(fruit, c('fruit','berry'))
setdiff(union(ind_fruit, ind_berry), ind_either )
```

#### find and replace

For find and replace operations, you can use one of `str_replace` or 
`str_replace_all`. The former matches only the first instance of pattern.
Similar base functions are `sub` and `gsub`. 

```{r str19}
# abc ... 
letter_vec = paste(letters, collapse = '')

## replace all instances
str_replace_all(letter_vec, '[aeiou]', 'X')

#replace the first instance
str_replace(letter_vec, '[aeiou]', 'X')
```

You can also find and/or replace by the position in a string using `str_sub`.
```{r str20}
# to replace by location
str_sub(letter_vec, start = 1:3, end = 2:4)
str_sub(letter_vec, start = -3, end = -1) = 'XXX'
```


#### splitting strings

The base function `strsplit` can be used to split a string into pieces based on 
a pattern. The example below finds all two-word fruit names from `fruit`.

```{r str21}
fruit_list = strsplit(fruit,' ')
two_ind = which(sapply(fruit_list, length)==2)
fruit_two = lapply(fruit_list[two_ind], paste, collapse=' ')
unlist(fruit_two)
```

The `str_split` function behaves similarly for this simple case. 
```{r str22}
all.equal(fruit_list, str_split(fruit, ' '))
```

When there are multiple patterns matching the split point, the functions
`strsplit` and `str_split` behave differently.

```{r str23}
string = '1;2,3'
strsplit(string, c(';', ','))
str_split(string, c(';', ','))

# Use a regular expression to split on either character. 
str_split(string,';|,')
```
