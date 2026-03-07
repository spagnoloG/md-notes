# Git

## Discard local changes

Discard unstaged changes in one file:

```bash
git restore path/to/file
```

Discard unstaged changes in all tracked files:

```bash
git restore .
```

Unstage files without touching the working tree:

```bash
git restore --staged path/to/file
git restore --staged .
```

Remove untracked files:

```bash
git clean -nd   # preview
git clean -fd   # delete files and dirs
```

## Add changes

Add one file:

```bash
git add path/to/file
```

Add everything:

```bash
git add -A
```

Stage selected hunks:

```bash
git add -p
```

## Branches

List branches:

```bash
git branch
git branch -r
git branch -a
```

Create and switch to a new branch:

```bash
git switch -c my-branch
```

Create a local branch that tracks a remote branch:

```bash
git switch --track origin/my-branch
```

## History

Show a compact graph:

```bash
git log --oneline --graph --decorate --all
```

Show one commit:

```bash
git show <commit>
```

## Undo the last local commit

Keep changes staged:

```bash
git reset --soft HEAD~1
```

Keep changes unstaged:

```bash
git reset --mixed HEAD~1
```

## Rebase local branch on latest main

Replace `main` if your default branch is different.

```bash
git fetch origin
git switch my-branch
git rebase origin/main
```

If there are conflicts:

```bash
git add <resolved-file>
git rebase --continue
git rebase --abort
```

## Squash recent commits

Squash the last `n` commits:

```bash
git rebase -i HEAD~n
```

In the editor keep the first commit as `pick` and change the rest to `squash` or `fixup`.

If the branch was already pushed:

```bash
git push --force-with-lease
```

## Restore a deleted file or directory

Restore from `HEAD`:

```bash
git restore path/to/file-or-dir
```

Restore from another commit:

```bash
git restore --source <commit> path/to/file-or-dir
```

## Recover a lost commit

Check the reflog:

```bash
git reflog
```

Create a branch from the old commit:

```bash
git branch recovered <commit>
git switch recovered
```

## Edit the last commit

Change the message:

```bash
git commit --amend
```

Change files in the last commit:

```bash
# edit files
git add -p              # or: git add -A
git commit --amend
git push --force-with-lease
```

## Pre-commit hooks

Install `pre-commit`:

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install pre-commit
pre-commit install
```

The config file is `.pre-commit-config.yaml`. Docs: https://pre-commit.com/

## Remove secrets from history

Rotate the secret first.

Rewrite history with `git-filter-repo`:

```bash
pip install git-filter-repo
printf 'old-secret==>REMOVED\n' > replacements.txt
git filter-repo --replace-text replacements.txt
git push --force --all
git push --force --tags
```
