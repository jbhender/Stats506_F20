## Examples

This directory will be used to share code for examples presented during
lecture or referenced in the reading.  

- [Rmarkdown.Rmd](./Rmarkdown.Rmd) - Source code for the Rmarkdown notes
   which you may find useful for learnig Rmarkdown.  Note that the icons are
   not included in this directory so you will need to remove reference to them
   if trying to render this example yourself.


### shell

The [shell](./shell) directory contains short examples illustrating
syntax for useful shell programming patterns. Here are short descriptions:

 - `dups.txt`, `nhanes_files.txt` example text files for use with the
    shell examples.
 - `ex_while_read.sh` illustrates the `while read` pattern for looping.
 - `ex_check_dup_lines.sh` illustrates checking for duplicate lines in
    a file using `sort`, `uniq`, `wc` and an `if` statement. The `if`
    statement syntax here is for bash and may error in other shells,
    e.g. zsh.
 - `ex_variable_expansion.sh` demonstrates the difference between single
    and double quotes in terms of the latter allowing variable expansion.

### Stata

 - `ex_io.do` - I/O commands: sysuse, clear, import delimited,
    export delimited, save

 - `ex_loops.do` - looping types with iterator as local macro

 - `ex_macros.do` - creating and acessing local macros; evaluate
    vs unevaluated macros.


### R

 - `ggplot_ex1.R` illustrate options for using aesthetics like color, shape
    together with facets and dodged positions to emphasize specfic comparisons.
    
### data
 - `recs2015_temps.RData` contains point and interval estimates for the
   average residential home temperatue in winter at 3 times of day by
   Census Division and urban type.  Estimates are from RECS 2015.
   