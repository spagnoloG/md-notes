# GIT

- If you want to revert changes made to your working copy, do this:
`git checkout .`
- if you want to revert changes made to the index (i.e., that you have added), do this. Warning this will reset all of your unpushed commits to master!
`git reset`
- if you want to remove untracked files (e.g., new files, generated files): `git clean -f` and dirs `git clean -fd`
- if you want only one file to be revetred
`git checkout HEAD -- TIS/tis.tex`
- Add all files in the repo
`git add -A`

### Accidentaly deleted a folder in a git repo?

```bash
git reset -- path/to/folder
git checkout -- path/to/folder
```

### List all branches
* local: `git branch`
* remote: `git branch -r`
* remote & local: `git branch -a`


You can also add `-v` flag to increase verbosity to get more details about listed branches.

### Display all commits to the branch in nice way
* `git show-branch -r`

### Switch to remote branch that is not on local computer

`git switch <branch_name>`


### I had many reduntant commits on this branch how would I squash them?
- If you have many redundant commits on your local branch and you want to squash them into a single commit, you can use the git rebase command with the interactive mode to rewrite the commit history.
Here are the steps to squash redundant commits on your local branch:

First, switch to your local branch by running the following command:

git checkout your_local_branch
Use the following command to start an interactive rebase:

```
git rebase -i HEAD~n
```

Replace n with the number of commits you want to include in the rebase. For example, if you want to squash the last five commits into a single commit, you would use git rebase -i HEAD~5.

This will open a text editor with a list of your recent commits. The word "pick" will appear before each commit. To squash the redundant commits, replace "pick" with "squash" or "s" for the commits that you want to squash into a single commit.

Save and close the file. Git will apply the changes and open another text editor to allow you to edit the commit message for the new squashed commit.

Edit the commit message as needed, then save and close the file.

Git will apply the changes and create a new commit with the squashed changes. If there are any conflicts, Git will pause the rebase process and prompt you to resolve them manually.

After you've resolved all conflicts, run the following command to continue the rebase:

```
git rebase --continue
```
If you encounter any issues during the rebase process, you can use the git rebase --abort command to abort the process and return your local branch to its original state.
Once the rebase is complete, your local branch will contain a single commit with the changes from the redundant commits squashed into it. You can then push your changes to your remote repository if needed.


### I have a local branch, but the main git branch was recently updated and I want those changes to be included into my local branch. How would I do that?
Here are the steps to follow to update your local branch using git rebase:

First, switch to your local branch by running the following command:
```
git checkout your_local_branch
```

Fetch the latest changes from the main Git branch by running:
```
git fetch origin
```
This command will update your local copy of the main Git branch to match the version on the remote repository.

Use the following command to start the rebase process:
```
git rebase origin/main
```

This will take the changes in the main branch and apply them to your local branch by replaying your local changes on top of them.

Resolve any conflicts that may arise during the rebase process. When there are conflicts, Git will pause the rebase process and show you which files have conflicts. You can then use a merge tool or a text editor to resolve the conflicts manually.

After you've resolved all conflicts, run the following command to continue the rebase:
```
git rebase --continue
```
This will apply the remaining changes and complete the rebase process.

If you encounter any issues during the rebase process, you can use the git rebase --abort command to abort the process and return your local branch to its original state.

Once the rebase is complete, your local branch will contain the changes from the main Git branch, and your local commits will be replayed on top of them. You can then push your changes to your remote repository if needed.


## Deleted a commit and want to revive it

### Firstly locate it
```bash
git fsck --full --no-reflogs --unreachable --lost-found | grep commit | cut -d " " -f 3 | xargs -n 1 git log -n 1 --pretty=oneline | grep "<commit-message>"
```
Then checkout to the that commit hash. Good luck ;)


## Edit last commit message
```bash
 git commit --amend
 ```

