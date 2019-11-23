#!/bin/bash

cat<<EOS

This program replaces the line "md.restart" in the system.cfg with a corresponding md.rst file.

EOS

set -Ceu

export PROJ_DIR=/work1/t2g-hp170020/siida/s100b_ctd_work

read -p "Previous iteration no: " pre
Current=`expr $pre + 1`
echo "Current: " $Current

list_pre_dirs=`ls -vd ${PROJ_DIR%/}/md${pre}/n*`

count=0
for nx in $list_pre_dirs; do
    count=$(( $count + 1))
    echo $count $nx
    cat ${PROJ_DIR%/}/md${Current}/n${count}/system.cfg | sed -e "s!md.restart!${nx}/md.restart!g" > tmp
    mv tmp ${PROJ_DIR%/}/md${Current}/n${count}/system.cfg
done

#Old version
#for i in `ls -vd n*`; do
#    echo $i
#    cat ${i}/system.cfg | sed -e "s!md.restart!../../md${pre}/${i}/md.restart!g" > tmp
#    mv tmp ${i}/system.cfg
#done
