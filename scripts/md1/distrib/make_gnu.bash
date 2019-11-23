#!/bin/bash


printf "plot " > plot.gnu
for i in $(seq 1 30)
do
   printf " '$i.pdf' w l lw 3, " >> plot.gnu
done
