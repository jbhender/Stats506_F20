## Groups

This is a group activity. You can view your group and assigned role at:

https://docs.google.com/spreadsheets/d/1r4OxLjU_oLbVDfyn7y066cc-Qe8HZNBE7zSDRKuoIlY/edit?usp=sharing

If someone is absent, please assign their role to another member of your group.
If you need to switch roles within your group, please edit the "roles" sheet
as needed.

### Roles

Project Manager - The person in this role should keep the group on task
by asking questions and making sure each member knows their role.
Help with other roles as needed.

Editor - The person in the Editor role should edit the group's 
scripts and share their screen with the group during the breakout sessions. 

Record Keeper - This person in this role should edit the google sheet with your
group's progress during the breakout sessions.

Questioner - The person in the questioner role should be prepared to ask the
group's questions when the class reconvenes as a whole. 

## Week 2 - R syntax and reasoning activity

The direct link to this page is:
https://github.com/jbender/Stats506_F20/tree/master/activities/week2/


### Question 1
For each snippet of **R** code below, compute the value of `z` without using
**R**.  You should assume each  snippet is run in a clean R session and that 
the chunks are independent. 

a.  What is the value of `z`?

```r
w = sum(1:100)
x = 2 * w
y = x > 5e3
z = typeof( c(x, y) )
```

b.  What is the value of `z`?

```r
x = -1:1
y = rep(1, 10)
z = mean(x * y)
```

c. What is the value of `z`?
```r
z = 10
f = function(input) {
 z = sqrt(input)
 return( z )
}
input = f(z * z)
output = f(input)
```

d. What is the value of `z`?
```r
start = 1
goal = 5^2
total = 0
while ( total <= goal ) {
 for ( i in 1:start ) {
    total = total + i 
 }
 start = start + 1
}
z = total
```

e. What is the value of `z`? 
```r
start = list(x = TRUE, y = 'two', z = floor(pi) )
start$xyz = with(start, c(x, y, z) )
out = lapply(start, class)
z = unlist(out)
```

f. What is the value of `z`? 
```r
  x = rep(1:3, each = 3)
  y = rep(1:3, 3)
  dim(x) = dim(y) = c(3, 3)
  z = t(x) %*% y
  z = z[, 3]
```

### Question 2

Which do you think is larger `e0` or `e1`? Why? What is the value of `z`?

```r
x0 = 1:10000
y0 = x0 * pi / max(x0)
e0 = sum( abs( cos(y0)^2 + sin(y0)^2 - 1 ) )

x1 = 1:100000
y1 = x1 * pi / max(x1)
e1 = sum( abs( cos(y1)^2 + sin(y1)^2 - 1 ) )

z = floor( e1 / e0 )
```

### Question 3

Consider an arbitrary *data.frame* `df` with columns `a`, `b`, and `c`. 

i. Which of the following is not the same as the others? 
  
  a. `df$a` 
  a. `df[1]` 
  a. `df[['a']]` 
  a. `df[, 1]`  
    
ii. Which of the following are equivalent to `length(df)`? 
      Choose all that apply.
      
  a. `nrow(df)`
  a. `ncol(df)`
  a. `3 * nrow(df)`
  a. `length(df[['a']])`
  a. `length(df[1:3])`
    
iii. Which of the following are equivalent to `length(df$a)`? 
     Choose all that apply.
       
  a. `nrow(df)`
  a. `ncol(df)`
  a. `3 * nrow(df)`
  a. `length(df[['a']])`
  a. `length(df[1:3])`
   
### Question 4

Read the R code below and determine the value of `twos` and `threes` at the end.

```r
twos = 0
threes = 0
for ( i in 1:10 ) {
  if ( i %% 2 == 0 ) {
    twos = twos + i
  } else if ( i %% 3 == 0 ) {
    threes = threes + i 
  }
}
```

### Question 5
Read the **R** code below and determine the value of `x` at the end.

```r
x = 0
for ( i in 1:10 ) {
  x = x + switch(1 + {i %% 3}, 1, 5, 10)
}
```
