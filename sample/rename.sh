#!/bin/bash
set -Ceu

j=0
for i in $(seq 1 3);do
    mv n$i/md_0.pdb initials/md_$j.pdb
    mv n$i/md_1.pdb initials/md_$(($j + 1)).pdb
    mv n$i/md_2.pdb initials/md_$(($j + 2)).pdb
    mv n$i/md_3.pdb initials/md_$(($j + 3)).pdb
    j=$(($j+4))
done
