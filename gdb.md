---
tags: [linux]
title: Gdb
created: '2021-12-05T22:45:44.151Z'
modified: '2021-12-05T22:46:14.308Z'
---

# Gdb

### Basics
- `r` ~ run program
- `ni` ~ step to next instruction
- `c` ~ coninue execution of program to breakpoint or end of program if no breakpoint is set
- `b *main` ~ add a breakpoint at main
- `b *0xdeadbeef` ~ add a breakpoint at a specific addres
- `info break` ~ list all breakpoints
- `delete breakpoint <number>` ~ delete breakpoint with provided `number` breakpoint identifier
- `x/30gx $rsp` ~ display first 30 values, after a stack pointer
- `x/s 0x0000000040080e` ~ display a **string** at provided addres
- `disass main` ~ disassembly provided function
- `x/4i 0x0000000000401393` ~ get 4 instructions on provided address

#### Show all secitons of a file
- `info file`

#### Display current state of registers
- `info registers`

#### List all maped memory regions
- `info proc mappings`

### Check protections used on a file
issue command `checksec`
- `Canary` ~
- `NX` ~
- `PIE` ~
- `Fortify` ~ nobody knows
- `RelRO` ~ 

### ROP gadgedts
- `~/.local/bin/ROPgadget --binary a.out`
- registers:
    - `rdi` ~ first argument
    - `rsi` ~ second argument

### HEAP
- `vis` ~ show heap visually
- `heap` ~ display chunks
- `bins` ~ diplay TCACHE, FASTBIN, UNSORTED BIN pointers
