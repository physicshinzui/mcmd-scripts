#/bin/bash

dir=md1
echo " Job = "$dir
echo " "
rm -r ${dir}
mkdir ${dir}
cp inp.dat_e1 ${dir}

nmax=30
cp nul aaa
for ii in $(seq 1 $nmax)
do
    echo $ii
    ff=../derv_den_Pc/${ii}/dden.dat
    ls -la ${ff}
    cat aaa ${ff} > bbb
    mv bbb aaa
done
cat ${dir}/inp.dat_e1  aaa > e1.fit
rm aaa

./aho.exe < e1.fit

mv e1.fit  ${dir}
mv fort.11 ${dir}/e1_fort.11
mv fort.12 ${dir}/e1_fort.12
mv fort.13 ${dir}/e1_fort.13
mv fort.16 ${dir}/e1_fort.16
mv fort.20 ${dir}/e1_fort.20
