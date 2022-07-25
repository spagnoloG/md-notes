# Named pipes

They are very useful for transmiting data of one linux process to another.

### Creation of named pipe
- `mkfifo my_pipe`

### Sending and recieving data
- `echo "Hello my friend!" > my_pipe` ~ sending data to pipe
- `tail -f my_pipe` ~ reading data from pipe
