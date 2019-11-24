# V-McMD scripts

## There are directoies, files, and scripts we must keep in mind:

### Directories
- `md1`    : to perform canonical MD runs so that the density of states (DOS) are estimated by multiple runs at different temperature [^dos_exp1].


[^dos_exp1]: We need to guess DOS at first! Just because we are not sure the value of DOS beforehand! We can't calculate the baias potential $E_{\rm mc}=RT\ln[n(E)]$ then.

- `mdx`    : to perform V-McMD iterations (x = 2, 3, 4,...)
- `inputs` : to contain a topology file, an initial structure one (.pdb), shake one, and atom group one[^atmgrp].

[^atmgrp]: atom group file describes groups of atoms you wanna handle during simulation.

### Scripts
- `md1_builder.sh` : to make md1 directory.
- `md1_exe.sh`     : to execute runs performed in md1.
- `mdx_builder.sh` : to make mdx directory
- `mdx_exe.sh`     : to execute runs in mdx
- `for_next.sh`    : to make parameters (DOS)[^dos] the next iteration runs inherit. 

[^dos]: More specifically, the parameters are coefficients of a polynomial function used to fit multicanonical flat distribution. 

- `kill_jobs.sh`   : to kill jobs on TSUBAME instantly. You can use it when you find runs wrong.

- `script/md1/derv_den_Pc`: 


### Actual Procedure
Not completed.

1. Put inputs in `inputs` dir.
2. Check `md1` 
3. `mdx`