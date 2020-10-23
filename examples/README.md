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

 - `ex_mata.do` - using Stata's "mata" language to work with
    matrices created by estimation commands.

 - `ex_frames.do` - using `frames` to work with multiple in-memory
    data sets. 

### R

 - `ggplot_ex1.R` illustrates options for using aesthetics like color, shape
    together with facets and dodged positions to emphasize specfic comparisons.

 - `tables_ex1.R` illustrates options for organizing tables 
    to emphasize specfic comparisons.

 - `secret_class.R` taken from 13.6.1 in
    [Advanced R](https://adv-r.hadley.nz/s3.html#s3-inheritance)
    illustrates how to use `NextMethod()` for efficient dispatch
    of inherited methods.

### SAS

 - [example0](./sas/example0.sas) illustrates options for data import
   and exploring a data file in memory.
   * `infile` statements
   * variable formats
   * `proc print`
   * `proc contents`
   * `proc import`

 - [example1](./sas/example1.sas) demonstrates use of SAS libraries
   and importing fixed width data using an `infile` statement. 
   * `libname` statements for creating library handles
   * `infile` statements for fixed width data

 - [example2](./sas/example2.sas) provides another demonstration of
   using `libname` and a two-part file name to save `sas7bdat` binaries
   to disk.

 - [example3](./sas/example3.sas) illustrates use of an existing `.sas7bdat`
   and emphasizes statements and options within SAS `proc` steps.

 - [example4](./sas/example4.sas) data step illustrations
   * subsetting with `if` (see also `where`)
   * implicit variable `_n_` for the row number

 - [example5](./sas/example5.sas) `proc tabulate` examples.
 
 
   
### data

 - `recs2015_temps.RData` contains point and interval estimates for the
    average residential home temperatue in winter at 3 times of day by
    Census Division and urban type.  Estimates are from RECS 2015.
  