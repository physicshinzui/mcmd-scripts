#!/bin/bash

set -eu

cd md1
for idir in `ls -d *`; do
  cd $idir
  pwd
  bash com_md
  cd ..
done
