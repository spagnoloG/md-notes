# EXEC

It is a family of functions that do the same thing but actually no.
When we call `exec()`, we never reutrn back to the callling program. The program
called by the `exec()` function replaces itself with the calling progam. The only way
that we could return to original process if `exec()` fails to execute.
Thats why we usually use `fork() & exec()`, so that we can safely return to main process
without losing anything :).

what stays:

- `PID`, `PPID`
- opened file descriptors
- current directory, root directory

what does not:

- code
- stack
- heap
- data

(new stack and new heap)

sufixes:

- `l` ~ arguments are passed as function arguments
- `v` ~ arguments are passed by char array
- `p` ~ search in `$PATH` for provided executable
- `P` ~ specifying that we will provide a path to an executable
- `e` ~ enviromental variables are provided in a char array
