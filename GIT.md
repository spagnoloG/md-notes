---
title: GIT
created: '2021-12-14T21:11:06.500Z'
modified: '2021-12-14T21:13:05.655Z'
---

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
