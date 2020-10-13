## Groups

This is a group activity. You can view your group
and assigned role at:

https://docs.google.com/spreadsheets/d/1r4OxLjU_oLbVDfyn7y066cc-Qe8HZNBE7zSDRKuoIlY/edit?usp=sharing

If someone is absent, please assign their role to another member of your group.
If you need to switch roles within your group, please edit the "roles" sheet
as needed. This will be the final week in these groups. 

If you see 'chat only' in the notes for a group member, please log into 
your umich Gmail account.  Then, have the project manager open a google chat 
for the group.  On the left-hand menu, click the `+` next to
'chat' and then select 'start a group conversation' and add your group members.
Thank you for your cooperation.

### Roles

**Project Manager** - The person in this role should keep the group on task
by asking questions and making sure each member knows their role.
Set up a Google Chat for the group if any members need to participate by
chat only. Help with other roles as needed.

**Editor** - The person in the Editor role should share their screen with the
group as needed during the breakout sessions to demo key steps for other group
members. 

**Record Keeper** - This person in this role should edit the google sheet 
with your group's progress during the breakout sessions. Update a step to "done"
only *after* everyone in the group has completed the step.  

**Questioner** - The person in the questioner role should be prepared to ask the
group's questions when the class reconvenes as a whole. 

## Week 6 - Demographic Tables

The direct link to this page is:
https://github.com/jbender/Stats506_F20/tree/master/activities/week6/

Academic papers reporting on human subjects usually include a "table 1"
summarizing the demographics of the subjects included.  This table is typically
stratified into columns by a key exposure, outcome, or other important variable.

When there are subjects with missing outcomes, it is common to include a table
like described above examining the (marginal) relationships between missingness and
key demographics. This helps an interested reader reason about possible selection
bias stemming from those for whom the outcome is observed being different in some
ways from those for whom it is not.

In this activity, we will construct a balance table comparing demogrpahics for those
who are or are not missing the oral health examination in the NHANES data.

Use R and the tidyverse for this activity. 

### Part 1  - Data Prep

In this part, you will read in the data and prepare to construct the table.
The data are available in this repository under `problem_sets/data/`. You
will need the following two files:

 * `nahanes_demo.csv`
 * `nhanes_ohxden.csv`

1. Write an R script to read in both data files.

2. The variable `OHDDESTS` contains the status of the oral health exam.
   Merge this variable into the demograhics data.

3. Create a clean dataset with the following variables:
  * `id` (from `SEQN`)
  * `gender`
  * `age`
  * `under_20` if age < 20
  * `college` - with two levels, 'some college/college graduate' or
     'No college/<20' where the latter category includes everyone under 20
     years of age.
  * `exam_status` (`RIDSTATR`)
  * `ohx_status` - (`OHDDESTS`)
  
4. Create a variable in the data frame above named `ohx` with two levels
   "complete" for those with `exam_status == 2` and `ohx_status == 1` or
   "missing" when `ohx_status` is missing or corresponds to "partial/incomplete."

5. Remove rows from individuals with `exam_status != 2` as this form of
   missingness is already acounted for in the survey weights.

### Part 2 - Construct a table / marginal tests

1. Construct a table with `ohx_status` in columns  and each of the following
   variables summarized in rows:
   * `under_20`
   * `gender`
   * `college`

2. For each cell in your table, provide a count (n) and a percent (of the row)
   as a nicely formatted string.

3. Include a column 'p-value' giving a p-value from a chi-squared test comparing
   the 2 x 2 tables for each demographic characteristic and OHX exam status. 

