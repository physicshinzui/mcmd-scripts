#!/bin/bash

set -eu 

read -p "virtual state no: " vstate_no

for i in {1..90}; do
    { echo $vstate_no; echo ${RANDOM}; } > start.vert

    if [ -e ../n${i}/start.vert ]; then
       echo "start.vert exists."
       exit 
    else
        echo mv start.vert ../n$i
        mv start.vert ../n$i
    fi
done

