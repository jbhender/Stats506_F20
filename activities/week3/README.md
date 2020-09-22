## Groups

This is a group activity. You can view your group and assigned role at:

https://docs.google.com/spreadsheets/d/1r4OxLjU_oLbVDfyn7y066cc-Qe8HZNBE7zSDRKuoIlY/edit?usp=sharing

If someone is absent, please assign their role to another member of your group.
If you need to switch roles within your group, please edit the "roles" sheet
as needed. This will be the final week in these groups. 

If you see 'chat only' in the notes for a group member, please log into your umich
Gmail account.  Then, have the project manager
open a google chat for the group.  On the left-hand menu, click the `+` next to
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

## Week 3 - Git and Markdown activity

The direct link to this page is:
https://github.com/jbender/Stats506_F20/tree/master/activities/week3/

This week's activity is intended to help you syntesize some of what you learned
about git and markdown over the past week. Each of you will create a remote 
git repository at https://www.github.com with a README and the shell scripts 
you wrote during the 
[week1](https://github.com/jbender/Stats506_F20/tree/master/activities/week1/)
activity.

### Part 1

 1. Go to https://www.github.com, login to your account, and create a public
    git repository named `Stats506_public`. Initialize your repository with a
    a README.md file.
    
 1. Clone the repository to your local computer and edit the README.md with a
    short "About" section. In the "About" section include links to the course
    homepage and to this (`Stats506_F20`) repository. Add the changes to the 
    staging area, commit them, and push to the remote you created in step 1. 
    
 1. After completing the previous step, edit the "Stats506_public" column on
    this week's "Roles" tab of Google sheet with a hyperlink to your repo.
    
 1. Create an "Activities" section in your README.md file and a "Weeks 1-3" 
    subsection. In the subsection, provide links to the `Stats506_public` pages
    for each of your group members. Then, using a bulleted or numbered list,
    write 1-2 sentences about each of the first three activities (including
    this one). Add, commit, and push these changes. 

### Part 2
In this part, you'll practice using branches in git. 

 1. In your `Stats506_public` repository, create a new branch `week1` using:
    `git branch week1`.  Type `git branch` to list available branches. Checkout
    the `week1` branch using `git checkout week1`. 

 1. While on the `week1` branch, create a folder `activities/week1` in your
    repository and copy the shell scripts your group wrote during the week 1
    activity to this folder. Create a new README.md file within `activities`
    and briefly describe each of these files. Add and commit these changes. 
    
    **Hint:** If not all group members have this file, you may want to clone 
    the week1 editor's repo (after they complete this step) and then copy the
    shell scripts there to your repo. 
    
 1. In this step you will push the `week1` branch you just created to the 
    remote (`origin`). However, this branch does not yet have an upstream 
    remote so push using: `git push --set-upstream origin week1`. 
    
 1. Checkout the `master` branch using `git checkout master`.  Are the files 
    you just added still in the file tree? Hopefully "no" as these files were
    add to the file tree while on the `week1` branch. Merge your changes from
    the week 1 branch into the `master` branch using (from the master branch):
    `git merge week1`.

 1. If the last step completed successfully, delete the `week1` branch (not 
    the week1 folders) using `git branch -d week1`. Verify this by listing
    the branches `git branch`. 
    
