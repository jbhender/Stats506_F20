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

## Week 7 - Programming with dplyr

The direct link to this page is:
https://github.com/jbender/Stats506_F20/tree/master/activities/week7/

One of the nice things about `dplyr` is its use of *tidy evaluation* which
enables us to write variable (column) names within `dplyr` verbs without
quotations. However, what is a feature for interactive use make programming with
`dplyr`, e.g. writing functions that use `dplyr` internally,  more challenging than it
is when working with functions which use standard evaluation. 

In this activity, you will learn about programming with `dplyr` by writing and generalizing a
function that use `dplyr` internally. 

Throughout, it will be helpful to refer to this page:

https://dplyr.tidyverse.org/articles/programming.html

The description at `help('nse-force')` is also helpful. 

Here is a short list of concepts.

1. Function arguments that refer to variables in a data frame (or tibble)
   are best passed as character vectors.
2. For `dplyr` functions that use *data masking*,
   + use the embracment operator `{{ }}` to defuse an argument
   + use the `.data` pronoun to refer to columns using `.data$x` or `.data[[var]]`.
   + use the "bang-bang" operator `!!` to force early evaluation.
3. For functions that use `tidy-select` Use existing methods for selecting with
   a character vector, e.g. `all_of()`.
4. Use `across()` for working with multiple variables.

You can see an example in my solution to last week's activity and a larger example in
my solution to problem set 2.

 * [nhanes_balance.R](../week6/nhanes_balance.R)

 * [2-ps2_q1_analysis.R](../../problem_sets/solutions/ps2/2-ps2_q1_analysis.R)

### Part 1

There are four tasks in [dplyr_proramming.R](./dplyr_programming.R).

1. Use `across()` to compute weighted means for all three
   temperature types.

2. Encapsulate the pattern from task 1 in a function. 

3. Write a function to add groups to a data frame / tibble.

4. Use the function you wrote in part 3  and the pattern from task 2
   to finish writing `recs_mean1()`.

5. Document your solutions in your `Stats506_public` GitHub repo.




