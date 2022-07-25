---
tags: [linux]
title: VIM
created: '2022-01-24T16:09:57.858Z'
modified: '2022-01-24T16:10:20.634Z'
---

# VIM
Comment Multiple Lines
- `:15,25s/^/#` ~  comment from line 15 to 25.
- `%s/foo/bar/g` ~ replace all apearances of `foo` with `bar` in whole file
- `s/foo//g` ~ delete all apearances of `foo` in a line
- `:[range]s/{pattern}/{string}/[flags] [count]` this is how it is structured out

### Navigation
- `hjkl` from now on use this keys
- `x[visual]` delete character at current pos
- `dw[visual]` delete a word

-- vimtutor 2.5


#### Nerdtree
- `s` - open horizontally
- `i` - open vertically

#### Panes
- `ctrl + w` - move through panes
- `ctrl + w s` - split horizontally
- `ctrl + w v` - split vertically 

### Coc

#### code navigation
- `VISUAL over function name -> gd` ~ go to function definition
- `VISUAL over data type -> gy / gi` ~ go to type definition
- `VISUAL over function/ datatype -> K` ~ show documentation
- `INSERT -> ctl + space` ~ toggle autosuggestions
- `ctl + o` ~ return back
- `VISUAL gf` ~ go to file
- `ctl + o` ~ take me where i have bene before
- `ctrl + i` ~ take me forward

### Save
- `:sav file.txt` ~ save new file
- `:new file.txt` ~ create new file and open horizontally
- `:vsp file.txt` ~ create new file and open vertically
