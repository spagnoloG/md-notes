# Tmux
### Window operations
- `ctrl+b c` - spawn new window
- `ctrl+b n` - move to next window
- `ctrl+b p` - move to previous window
- `ctrl+b 0..9` - switch to window by number
- `ctrl+b x` - kill current window

### Panes
- `ctrl+b %` - spawn new pane horizontally
- `ctrl+b "` - spawn new pane vertically"
- `ctrl+b arrow_key` - switch through panes
- `ctrl+b ctrl + arrow_key` - resize pane
- `ctrl+b o` - switch to next pane 
- `ctrl+b loong o` - switch panes :sunglasses:
- `ctrl+b space` - toggle pane layouts
- `ctrl+b !` - convert pane into a window
- `ctrl+b x` - kill current pane
- `ctrl+b { or }` - Move the panes 


### Tms written in rust (https://github.com/jrmoulton/tmux-sessionizer)
Very useful for fuzzy finding git projects in your filesystem.

```bash
 tms config --paths /home/<user>/Documents/
````

then just run tms and fuzzy find your project. The tms will
then create a new session for you and also activate venv if you have 
it configured. Which is awesome.

## Rename pane :)
`ctrl+b ,`


## Multiple ssh servers ?
no problem

```bash
#!/bin/bash

ssh_list=( user1@server1 user2@server2 ... )

split_list=()
for ssh_entry in "${ssh_list[@]:1}"; do
    split_list+=( split-pane ssh "$ssh_entry" ';' )
done

tmux new-session ssh "${ssh_list[0]}" ';' \
    "${split_list[@]}" \
    select-layout tiled ';' \
    set-option -w synchronize-panes
```
[source](https://unix.stackexchange.com/a/533673)


## Source updated config file?

`:source-file ~/.tmux.conf`

## Problems on server?

```bash
root@ml-node:~# tmux
missing or unsuitable terminal: alacritty
# Fix, export a terminal variable
export TERM=xterm-256color
```

