## Week 1 - Shell scripting activity

The direct link to this page is:
https://github.com/jbender/Stats506_F20/tree/master/activities/week1/

In this activity you will have an opportunity to practice Linux
shell skills. Throughout the activity, you will use a terminal application
and a text editor to develop shell scripts for performing common data 
management tasks.

Prior to the activity, be sure to review the roles assigned to your group. 
If anyone from your group is absent, please assign there role to another member
of the group.

Record keeper: please record your groups progress at:


If the record keeper has trouble accessing the link, please sign into your
umich gmail account: https://mail.umich.edu. 

## Pre-requisites

Prior to the activity, please make sure you have:

1. Identified a terminal application you can use
1. Watched the Linux Shell Skill videos
2. Read the Linux Shell Skill notes

## Activity

This activity consists of three parts:

  0. In Part 0, you'll ssh to a linux server and prepare your workspace.

  1. In Part 1, you will write short code segments to download data from 
the Residential Energy Consumption Survey 
[RECS](https://www.eia.gov/consumption/residential/data/2015/index.php?view=microdata). 

  2. In part 2, you will write a shell program for extracting specific columns
  from a delimted data file. 

### Part 0 - Prepare your workspace

1. Use `ssh` to connect to a linux server from the pool `login.itd.umich.edu`
1. Once you login, create a new tmux session and split your screen into two panes
or windows.
1. Use git to clone the Stats506_F20 repository:
`git clone https://github.com/jbhender/Stats506_F20.git`
or, if you've done so previously, `git pull` to get the most up-to-date version.
1. Change directories to `Stats506_F20/activities/week1/`
1. Use `emacs` or your preferred text editor to open `week1_part1.sh`.
1. In a separate window, move to the same directory and execute the template:
`bash ./week1_part1.sh`.

### Part 1 - Download RECS and extract columns by name

Look for numbered comments like `#<1>` for locations in `week1_part1.sh` 
you should edit. 

1. Modify the header with information about your group and the current date. 
1. Create variables "file" and "url" with the name of the csv file to be 
   downloaded and the download url. 
1. Download the data whenever the test for whether the file exists fails.
1. Write a "one-liner" - a single series of commands connected by pipes 
   and file redirections - to extract the header row of the RECS data, 
   translate (`tr`) the commas to new line characters ('\n'), 
   and write the results to the `recs_names.txt`. 
1. Write a one-liner that uses `recs_names.txt` and finds the column positions
   for the id (`DOEID`) and replicate weight columns (`BRR1`-`BRR96`) and then
   reformats these positions as a single, comma-separated string. The format of
   this string should be suitable for passing to the `-f` option of the `cut`
   command. 

### Part 2 - Modify the previous script into an executable program. 

We may skip this section depending on time. 

## Hints

If you get stuck, click on the links below for some hints for each step above.
Try to accomplish each step on your own prior to viewing the hint. 

### Part 0
<details>
  <summary> Step 1 Hint </summary>

  #### Mac Users 
  1. open the 'terminal' application
  2. ssh using your unique name `ssh unique_name@login.itd.umich.edu`
  3. your unique name is the part of your @umich.edu email address prior to the @.

  #### Windows Users
  Use [putty]() and connect to host `login.itd.umich.edu` or 
  the command line interface from [Git for Windows]() and refer to hints b and c
  for Mac Users, above.
  
</details>

<details>
 <summary> Step 2 Hint </summary>

 1. Create a tmux session: `tmux new -s Stats_506`
 2. Split your screen into two panes `cntrl+b %` e.g. `cntrl+b <shift>+5`
 3. To toggle between panes, use `cntrl+b ->` where `->` is an appropriate arrow key
    (left, right, up, or down). 
 4. For small screens, you may prefer windows to panes. In this case,
    use `cntrl+b c` to create a window  and toggle with `cntrl+b n` or `cntrl+b p`.

</details>


### Part 1

<details>
 <summary> Steps 1-3 Hints </summary>

 1. Update the author names and date and remove 'template' from the description. 
 2. Revisit the description after completing all steps.
 3. To download, use `wget` e.g. `wget $url`. 

</details>

<details>
 <summary> Step 4 Hint </summary>
 
 1. Break 1-liners into steps and test as you go:
  - What file will you operate on?
  - What command will extract just the header row?
  - How to pass the header row to a new command?
  - What command will translate commas to new line characters?
  - Where should the output go?
 1. See `man tr`.
 1. If you're not getting new lines from `tr` consider the difference in output
    between: `echo \n` and `echo \\n`. Slashes represent escape characters and often
    need to be repeated when parsed.

</details>
 
<details>
  <summary> Step 5 Hint </summary>

 1. Use `grep` to find matching lines. Review the options `-n, -e, -E`. 
 1. Use a regular expression to match DOEID or starts with BRR. 
 1. See `man cut` used in the next step and review the `-f` option for
    specifying fields. 
 1. Use `cut` to extract just line numbers from the `grep` output.
 1. See `man paste` for options and use an explicit `-` to input to paste from `stdin`.
    For example, create a test file `echo a > test.txt; echo b >> test.txt` and observe
    that `<test.txt paste -s` and `cat test.txt | paste -s -` have the same output.
 
</details>

### Part 2
