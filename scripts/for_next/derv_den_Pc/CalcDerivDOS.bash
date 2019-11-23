#!/bin/bash

set -eu
Md1DirPath="/work1/t2g-16IJ0004/siida/02_s100b_ctd_work/md1/"
DistribPath="/work1/t2g-16IJ0004/siida/02_s100b_ctd_work/for_next/distrib/pdf_res"
#DistribPath="/work1/t2g-16IJ0004/siida/02_s100b_ctd_work/tools_forPrepBySinzi/prep_mcmd/pdf_data"

#***making a file describing values of scale factors
python get_scaleFactors.py ${Md1DirPath%/}

Ts=$(cat TsOut.inp)
echo $Ts

ifort -o derv_de_Pc.exe derv_den_Pc.f
i=1
for T in $Ts; do
  rm -rf $i
  mkdir  $i
## In.
  ln -s  ${DistribPath%/}/${i}.pdf fort.10
  #ln -s  ${DistribPath%/}/e${i}.pdf fort.10
  ls -l fort.10
## Out.
  ln -s  ${i}/dden.dat  fort.20

  ./derv_de_Pc.exe $T > ${i}/calc.log
  rm fort.10  fort.20
  i=$(($i + 1))

done

exit
#
#####################################
#ifort -o abc.exe  derv_den_Pc.f
#####################################
#@ kk = 1
#while ( $kk <= ${nstage} )
#  if( $kk == 1) set t = 629.0212
#  if( $kk == 2) set t = 592.0200
#  if( $kk == 3) set t = 559.1300
#  if( $kk == 4) set t = 529.7021
#  if( $kk == 5) set t = 503.2170
#  if( $kk == 6) set t = 479.2543
#  if( $kk == 7) set t = 457.4700
#  if( $kk == 8) set t = 437.5800
#  if( $kk == 9) set t = 419.3475
#  if( $kk == 10) set t = 402.5736
#  if( $kk == 11) set t = 387.0900
#  if( $kk == 12) set t = 372.7533
#  if( $kk == 13) set t = 359.4407
#  if( $kk == 14) set t = 347.0462
#  if( $kk == 15) set t = 335.4780
#  if( $kk == 16) set t = 324.6561
#  if( $kk == 17) set t = 314.5106
#  if( $kk == 18) set t = 304.9800
#  if( $kk == 19) set t = 296.0100
#  if( $kk == 20) set t = 287.5526
#
#  rm -r ${kk}
#  mkdir ${kk}
#  echo $t > ${kk}/inp 
#
#  echo $kk $t
#
##  In.
#  ln -s  ../distrib/${kk}/e1.pdf  fort.10
##  Out.
#  ln -s  ${kk}/dden.dat  fort.20
#
#  ./abc.exe < ${kk}/inp > ${kk}/aho.dat
#
#  rm fort.10  fort.20
#
#  @ kk ++
#end
#
#rm abc.exe
#
#exit
