#!/bin/bash
set -ue

echo "**************************************************"
echo "* Please make nvert.dat range.dat by your hands. *"
echo "**************************************************"

printf "WORK_DIR(FULL PATH):" 
read WORK_DIR
printf "Current  md No:"
read iter

echo " "
echo " Current  md No = " $iter
echo " "
pre=`expr $iter - 1`

#**Compile
ifort -o set_vert.exe set_vert.f

if [ ${pre} -eq 2 ]; then
    nxs=`ls -vd ${WORK_DIR%/}/md${pre}/*/n*`
    ls -vd ${WORK_DIR%/}/md${pre}/*/n* | wc -l
elif [ ${pre} -gt 2 ]; then
    nxs=`ls -vd ${WORK_DIR%/}/md${pre}/n*`
    ls -vd ${WORK_DIR%/}/md${pre}/*/n* | wc -l
fi
    
#***Put start vert into each directories (n1,n2,...)
i=1
for nx in $nxs; do
  #echo $nx
  tail -1 ${nx}/mult.ene > last_ene.dat
  ./set_vert.exe < range.dat
  echo $RANDOM >> start.vert
  if [ -e ${WORK_DIR%/}/md${iter}/n${i}/start.vert ]; then
     echo "???start.vert exists.???"
     exit
  elif [ ! -e ${WORK_DIR%/}/md${iter}/n${i}/start.vert ]; then
     mv start.vert  ${WORK_DIR%/}/md${iter}/n${i}
  fi
  i=`expr $i + 1`
done

