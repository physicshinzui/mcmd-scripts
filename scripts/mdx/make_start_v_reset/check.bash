#/bin/bash

read -p "Previous iteration no: " pre
read -p "no of runs: " nruns


for i in $( seq 1 $nruns); do
    tail -n 1 ../md${pre}/n$i/ttp_v_mcmd.out | awk '{print $2}'
    head -1 n$i/start.vert
    sleep 0.2s
    echo 
done
