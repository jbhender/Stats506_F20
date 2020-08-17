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

Record keeper: please record your groups progress

If the record keeper has trouble accessing the link, please sign into your
umich gmail account: https://mail.umich.edu. 

## Pre-requisites

Prior to the activity, please make sure you have:

1. Identified a terminal application you can use
1. Watched the Linux Shell Skill videos, especially:
  a.
  a.
  a.
2. 

## Activity

This activity consists of three parts:

  0. In Part 0, you'll ssh to a linux server and prepare your workspace.

  1. In Part 1, you will write short code segments to download data from 
the Residential Energy Consumption Survey [RECS](). 

  2. In part 2, you will write a shell program for extracting specific columns
  from a delimted data file. 


### Part 0 - Prepare your workspace

1. Use `ssh` to connect to a linux server from the pool `login.itd.umich.edu`
1. Once you login, create a new tmux session and split your screen into two panes
or windows.
1. Use git to clone the Stats506_F20 repository:
`git clone https://github.com/jbhender/Stats506_F20`
or, if you've done so previously, `git pull` to get the most up to date version.
1. Change directories to `Stats506_F20/activities/week1/`
1. Use `emacs` or your preferred text editor to open `week1_part1.sh`.
1. In a separate window, move to the same directory and execute the template:
`bash ./week1_part1.sh`.

### Part 1 - 

Look for numbered comments like `#<1>` for locations in `week1_part1.sh` 
you should edit. 

1. Modify the header with information about your group and the current date. 
1. Create variables "file" and "url" with the name of the csv file to be downloaded and
 the download url. It may help to download it directly first. 
1. Download the data if the test for whether the file exists fails.
1. Write a "one-liner" -- a single series of commands connected by pipes and file redirections -- to extract the header row of the RECS data, translate (`tr`) the commas to new line characters, and write the results to the `recs_names.txt`. 
1. Write a one-liner that uses `recs_names.txt` and finds the column positions for 
the id (`DOEID) and replicate weight columns (`BRR1`-`BRR96`) and then reformats
 these positions as a single, comma-separated string. The format of this string should
be suitable for passing to the `-f` option of the `cut` command. 

### Part 2

## Hints

If you get stuck, click on the links below for some hints for each step above.
Try to accomplish each step on your own prior to viewing the hint. 

### Part 0
<details>
  <summary> Step 1 Hint </summary>

  #### Mac Users 
  a. open the 'terminal' application

  b. ssh using your unique name `ssh unique_name@login.itd.umich.edu`

  c. your unique name is the part of your @umich.edu email address prior to the @.

  #### Windows Users
  Use [putty]() and connect to host `login.itd.umich.edu` or 
  the command line interface from [Git for Windows]() and refer to hints b and c
  for Mac Users, above.
  
</details>

<details>
 <summary> Step 2 Hint </summary>

 a. Create a tmux session: `tmux new -s Stats_506`

 b. Split your screen into two panes `cntrl+b %` e.g. `cntrl+b <shift>+5`

 c. To toggle between panes, use `cntrl+b ->` where `->` is an appropriate arrow key
 (left, right, up, or down). 

 d. If you prefer windows, use `cntrl+b c` and toggle with `cntrl+b n` or `cntrl+b p`.

</details>


### Part 1


### Part 2