#!/bin/bash
set -Ceu
Md1DirPath="../../../md1/" # which contains data
DistribPath="../distrib/pdf_res"

#***making a file describing values of scale factors
python ./src/get_scaleFactors.py ${Md1DirPath%/}

Ts=$(cat TsOut.inp)
echo $Ts

gfortran -o derv_de_Pc.exe ./src/derv_den_Pc.f

i=1
#***Loop for temperature directories, 1,2,3,...
for T in $Ts; do
    [ -e $i ] && { rm -rf $i; mkdir $i; }
    [ -e $i ] || mkdir $i
## In.
    ln -s  ${DistribPath%/}/${i}.pdf fort.10
    ls -l fort.10
## Out.
    ln -s  ${i}/dden.dat  fort.20

    ./derv_de_Pc.exe $T > ${i}/calc.log

    rm fort.10  fort.20
    i=$(($i + 1))
done
rm derv_de_Pc.exe
