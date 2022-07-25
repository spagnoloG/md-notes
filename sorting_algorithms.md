# Sorting algorithms

### FCFS
Basically a fifo

### RR - round robin
Round robin


### SFJ
Shortest first

### PSFJ
Preemptive
Sepravi ti gledas tuki
recimo da mas 
A =  100
B = 20
C = 10

pa uzames najprej A, potem A splitas po C ju, ker ima C najmanjso casovno obdelavo. Aka vedno uzames 10

zgleda tko : A[0:10], pol B[0:10], pol C[0:10],pole A[10:20], B[10:20], A[20:90]


### Stride

Najprej uzames najbol levega /shrug
a = step 10
b = step 30
c = step 20

Nato vedno v vsaki iteraciji pristejemo originalno ceno

        A           B           C
        0           0           0
        10          0           0
        10          0           20
        10          30          20
        20          30          20

Pol pa mamo se un kurac od krititcnega stanja
# Kriticno stanje

```c
// random primer
x = 1 -> A_1
y = 2 -> B_1

x = x + y -> A_2
y = x - y -> B_2
```
Pol gremo samo probat use mozne kombinacije

sepravi A_1 B_1 A_2 B_2 --> in zracunas nc kej takega, lp in lpp

atomarne operacije aka prireditvne in ne prisevanje / odstevanje se morejo vedno najprej izvest, v nasprotnem primeru 
sploh nemores npr prsiteti x-a in y-a ---> segmetnation fault
