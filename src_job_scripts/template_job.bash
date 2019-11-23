#!/bin/bash
set -eu

###old version ~2017-4-17
#export OMEGATK=/work1/t2g-16IAN/siida/celeste/toolkit
#export LD_LIBRARY_PATH=/usr/apps.sp3/cuda/6.0/lib64:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/work1/t2g-16IAK/lib:${LD_LIBRARY_PATH}
#celeste=/work1/t2g-16IAK/bin/omegagene_gpu_038

#2017-4-17~
export OMEGATK=/home/usr7/15IH0406/toolkit
export LD_LIBRARY_PATH=/usr/apps.sp3/cuda/6.0/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/usr7/15IH0406/lib:${LD_LIBRARY_PATH}
celeste=/home/usr7/15IH0406/bin/omegagene_gpu_038

cd ${PBS_O_WORKDIR}

for i in $(seq #{FIRST} #{LAST} ) 
do
  cd n${i} 
#  python ${OMEGATK}/presto_generate_velocities.py \
#         -i      /work1/t2g-16IAN/siida/02_s100b_ctd_work/inputs/npt_1.pdb \
#         --i-tpl /work1/t2g-16IAN/siida/02_s100b_ctd_work/inputs/all.tpl \
#         --i-shk /work1/t2g-16IAN/siida/02_s100b_ctd_work/inputs/all.shk \
#         -t 650          \
#         -s $RANDOM      \
#         -o init.restart \
#         --mol --check > make_restart.log 
  python ${OMEGATK}/mdinput_generator.py -i system.cfg -o md.cls -v v.0.36.f > mdinpgen.out 2>&1
  $celeste --inp md.cls --cfg md.inp > md.out &
  cd ..
done
wait
