# Fork

### What happenes when you call `fork()` in your program?
Parent creates a child and spawns it, it is basically a copy of a parent process

excluding:
- `PID`, `PPID`
- file locks, mutex locks, any other locks...

including:
- same code
- !copy! of same heap and stack
- opened files

### Example
```c
int pid = fork()
if (pid > 0){
    // parent process
} else if (pid == 0) {
    // child process
} else {  // pid < 0
    // we encountered err!
}
```

### What happenes when cild process is exited?
Exit status is saved in process descriptor, until parent process waits for it.
Until exit status is not taken then we say that the process is **zombie**:
- proces is exited, and it does not take any system resources.
- only its process descriptor is not yet taken
- and we do not want many zombies in our system


### How parent knows, that the child process has been terminated?
Well we can use `singal()` to notify parent when the child process exits. Namely signal `WAITCHLD`.

Waiting for specific child:
```c
waitpid(pid, &status, options)
```
Waiting for any child:
```c
wait(&status);
// or 
waitpid(-1, &status, 0):
```

### Exit statuses
- 8bit value
- 0 means success
- 1-127 error
- 128-255 termination becouse of singal (`sig_num = status - 127`)

## `vfork()` function
V fork is a modified fork, which does not copy any data. It is meant to be used with comibnation with function `exec()`.
