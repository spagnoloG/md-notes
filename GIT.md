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
