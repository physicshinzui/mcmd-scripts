#!/bin/bash
set -eu

cat << EOS

Usage:
  bash $0 [job name]

EOS

job_name=$1

job_ids=`qstat | grep $job_name | awk '{print $1}'`

for id in $job_ids
do
  echo "Killing: " $id
  qdel $id 
  sleep 0.3
done
