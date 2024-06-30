# WFDB

- `sampfreq <filename>` ~ Get the sampling frequency
- `rdsamp -r s20011 | head` ~ Print the first 10 lines of the record

```text
              0	     55	     81
              1	     55	     84
              2	     55	     87
              3	     56	     89
              4	     57	     91
              5	     61	     93
              6	     65	     95
              7	     67	     99
              8	     69	    103
              9	     72	    105
```

- `rdsamp -r s20011 -t 0:00:02.00 | less` ~ Print the first 2 seconds of the record

- Plot samples using octave

```bash
rdsamp -r s20011 -f 0 -t 0:00:02.00 > sample.txt # Store the first 2 seconds of the record in a file
gnuplot
plot "sample.txt" using 1:3 with lines # x-axis: 1st column, y-axis: 3rd column
replot "sample.txt" using 1:2 with lines # x-axis: 1st column, y-axis: 2nd column
```

- Or save the plot

```bash
gnuplot
set term png
set output "sample.png"
plot "sample.txt" u 1:2 w l, "sample.txt" u 1:3 w l
```

- `rdann -r s20011 -a atr | more` ~ Print annotations; explanation of [annotations](https://www.physionet.org/physiotools/wpg/wpg_36.htm).
- `wrann -r s20011 -a qrs < s20011.asc` ~ Write annotations to file
- `wfdb2mat -r s20011 -f 0 -t 12` ~ Convert to matlab format
- `wfdb2mat -r s20011 -f 0 -t 12 > s20011m.info` ~ Save the stdout info in a file, matlab needs it for plotting
