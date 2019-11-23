#!/bin/bash

njobs=60 
first=1
last=`expr $first + 2`

for i in $(seq 1 $njobs)
do
  echo "Job $i: " $first " " $last
  cat template_job.bash| sed -e "s!#{FIRST}!${first}!g" -e "s!#{LAST}!${last}!g" > job_${i}.bash
  chmod +x job_${i}.bash
  first=`expr $last + 1`
  last=`expr $first + 2`
done
