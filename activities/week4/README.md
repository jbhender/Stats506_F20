## Groups

This is a group activity. You can view your group (new this week) 
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

## Week 4 - Into the Tidyverse

The direct link to this page is:
https://github.com/jbender/Stats506_F20/tree/master/activities/week4/

### Part 0 (git)

In your `Stats506_public` repo created last week, add a section `Weeks 4-6` to
your `README.md` in the `activities` folder with links to your new group
members `Stats506_public` repos. (If you weren't here last week, you'll
need to create the repo first). Copy a link to this page to the 
"Stats506_public" column unde the roles for this week.  

### Part 1 (dplyr)

Use the provided Rmarkdown template [week4_part1.Rmd](./week4_part1.Rmd)
to answer this question. 

It's fine for the group to produce a single file as long as everyone is
included as an author in the header and everyone pushes it to their repo in 
step 6. 

In the first part of the activity you will write or interpret short dplyr pipes
that explore or analyze the `Orange` data from R's `datasets` package. The data
which contains 35 rows and 3 columns recording the growth
of orange trees.  The dataset's three columns are:

  - `Tree`: an ordered factor, identifying individual trees, 
  - `age`: a numeric vector giving the number of days 
    since the tree was planted,
  - `circumference`: a numeric vector recording the circumference of the 
    trunk in mm. 

You can read more at `?Orange`. 

1. Write a dplyr pipe to determine the number of
observations per tree.

2. Write a dplyr pipe to change the units of age to "years" 
and circumference to "cm".
 
3. Write a dplyr pipe to add a column assigning a
z-score to each tree, centered around the mean for all trees at a given age.
 
4. Write a dplyr pipe to calculate the average rate of growth
(cm/year) across all trees between between age 0 (assume circumference = 0) and
the final measured age for each tree.

5. Describe the result of the following pipe in 1-3 sentences. Your
    *description* should touch on both the rows and columns and also describe
    a substantive question addressed by the result. 

```r
 Orange %>%
   group_by(Tree) %>%
   mutate( 
     new_growth = c(circumference[1], diff(circumference)),
     elapsed = c(age[1], diff(age))
   ) %>%
   group_by(age) %>% 
   summarize( 
     avg_rate = mean(new_growth / elapsed),
     se = sd( new_growth / elapsed ) / sqrt(n()) 
   )
```

6. Push your `week4_part1.Rmd` file to your `Stats506_public` repo into a new
   `week4` folder.  

### Part 2 (ggplot2)

In this part of the activity, you will use the summary data includned in this 
repo to reproduce the plot in each question using ggplot. The data represents
summary results from an analysis of the 2015 RECS data comparing the proportion
of homes with internet access by Urban (including Urban Cluster) and Rural
status within each Census Division. 

Use the provided template [week4_part2_solution.Rmd](week4_part2_solution.Rmd)
to produce your solution. Some preparatory work is done for you to facilitate
plotting, but you may need to make additional changes to the input data 
structure. 

---

1. Here is the plot you are targeting for q1.

![](./w4_p2_q1_plot.png)

---

2. Here is the target plot for q2. 

![](./w4_p2_q2_plot.png)

---

3. Push your results to the `week4` folder of your `Stats506_public` repo. 
In your README, include the plots you produced using the markdown syntax:
`![](./your_plot.png)`. Your plots should also be pushed to the repo.

