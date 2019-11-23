#!/bin/bash

set -ue
cat << EOS
Usage:
  $0 [INPUT md1 directory path ] 
EOS

rm -rf ? ??

Md1Dir=$1
for i in `ls $Md1Dir`;do
  cp -r master_dir ${i}
  cd ${i}
  ./01_link_ene ${Md1Dir%/}/${i}
  cd ..
done
