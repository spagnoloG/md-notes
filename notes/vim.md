# VIM

Comment Multiple Lines

- `:15,25s/^/#` ~ comment from line 15 to 25.
- `%s/foo/bar/g` ~ replace all apearances of `foo` with `bar` in whole file
- `s/foo//g` ~ delete all apearances of `foo` in a line
- `:[range]s/{pattern}/{string}/[flags] [count]` this is how it is structured out

### Navigation

- `hjkl` from now on use this keys
- `x[visual]` delete character at current pos
- `dw[visual]` delete a word

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

### Terminal mode

- `:term` ~ open terminal
- `ctrl +  \ and then ctrl +n` ~ Go into visual mode

### Shell output into vim

`:r !ls` ~ paste the output of ls into vim

### Multiline macro

Record a macro with `qa` where `a` is the register name

Then do the macro and then stop recording with `q`

Then run the macro with `@a` where `a` is the register name

then:
`:5,10norm! @a` ~ run the macro from line 5 to 10
`:5,$norm! @a` ~ run the macro from line 5 to end of file
`:%norm! @a` ~ run the macro on the whole file
`:g/pattern/norm! @a` ~ run the macro on all the lines that match the pattern

To execute the macro on visually selected lines, press V and the j or k until the desired region is selected.
Then type `:norm! @a` and observe the that following input line is shown.

### Nvim tree mappings

` :help nvim-tree-default-mappings`

### Delete all the whitespaces

```bash
:g/^$/d
```

## Marks

Add mark with `ma`

And then list them with `:marks`

Select the mark with `'x` where x is the character thas is next to the mark listed using `:marks` command.

|  Command  |                          Description                          |
| :-------: | :-----------------------------------------------------------: |
|    ma     |             set mark a at current cursor location             |
|    'a     |  jump to line of mark a (first non-blank character in line)   |
|    `a     |         jump to position (line and column) of mark a          |
|    d'a    |          delete from current line to line of mark a           |
|    d`a    |   delete from current cursor position to position of mark a   |
|    c'a    |        change text from current line to line of mark a        |
|    y`a    | yank text to unnamed buffer from cursor to position of mark a |
|  :marks   |                  list all the current marks                   |
| :marks aB |                        list marks a, B                        |
