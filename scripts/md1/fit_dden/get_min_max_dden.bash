#!/bin/bash

Upper_Bound=`tail -1 ../derv_den_Pc/1/dden.dat | awk '{print $1}'`
Lower_Bound=`head -1 ../derv_den_Pc/30/dden.dat| awk '{print $1}'`
echo ${Lower_Bound} ${Upper_Bound}

cat inp.dat_e1 | sed -e "s!#{LOW_BOUND}!${Lower_Bound}!g" | sed -e "s!#{UPPER_BOUND}!${Upper_Bound}!g"
