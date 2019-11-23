#!/bin/bash

cd md1
for idir in `ls -d *`; do
  cd $idir
  pwd
  echo bash com_md
  cd ..
done
