# FZF

- `history | fzf` ~ search through command history
- `cd $(find . -type d | fzf)` ~ search and change to a directory
- `kill -9 $(ps aux | fzf | awk '{print $2}')` ~ select and kill a process
- `git checkout $(git branch | fzf)` ~ switch between git branches
- `git log --oneline | fzf` ~ search through git commit history
- `vim $(fzf)` ~ open file in vim (enhanced with fzf integration)
- `vim $(find ~/.* -type f | fzf)` ~ find and edit configuration files in home directory
- `systemctl status $(systemctl | grep service | fzf | awk '{print $1}')` ~ select and view the status of a systemd service
- `mpv $(find ~/Music -type f | fzf)` ~ find and play a music file with mpv
- `docker logs $(docker ps | fzf | awk '{print $1}')` ~ select a running docker container and view its logs
- `ssh $(grep Host ~/.ssh/config | awk '{print $2}' | fzf)` ~ select and connect to an SSH host defined in ~/.ssh/config



