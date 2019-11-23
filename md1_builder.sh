#!/bin/bash
set -eu

# For TSUBAME
source /etc/profile.d/modules.sh
module unload python-extension/3.4
module load python-extension/2.7
WORK=/gs/hs0/hp170020/kasahara/
export KKTOOLS=${WORK}/kktools
OMGROOT=${WORK}/omegagene/og0_v039p
OMGTK=${WORK}/omegagene/og0_v039p/toolkit
OMG=${OMGROOT}/omegagene_gpu
export LD_LIBRARY_PATH=/gs/hs0/hp170020/kasahara/omegagene/og0_v039p:$LD_LIBRARY_PATH

#For my local
#export OMGTK=/Users/siida/Dropbox/01code/omegagene/omegagene-master/toolkit/

cat << EOS

        ~ Estimation of the Density of States ~
I buid directories for canonical runs at various temperatures.

EOS
SECOND=0
#Jugdge if md1 exists.
if [ -e "md1" ]; then
    echo "md1 exists. STOP. If you wanna go on, delete it beforehand."
    exit 
else
    mkdir md1
fi

cat << EOF
Did you put input files in input directory?:
    - system.tpl
    - system.shk
    - atom_groups.inp
EOF
read -p "Enter"

#read -p "For a start, I'll show you some scripts to check if paths are correct.[if ok enter]"
#vim scripts/md1/run.pbs
#vim scripts/md1/com_md

read -p "No. of runs for each temperature    :" NRUNS 
read -p "No. of temperature you will simulate:" NTEMP 
read -p "Tell about lower scale factor (see scripts/md1/factor_vs_T.txt):" L_SCALE_FACT 
read -p "Tell about upper scale factor       :" H_SCALE_FACT

TMPL_mdrun="../../../scripts/md1/tmpl/md.inp.run"
TMPL_syscfg="../../../scripts/md1/tmpl/system_base.cfg"
TMPL_ttpinp="../../../scripts/md1/tmpl/pre_ttp.inp.tmpl"
LOC_runpbs="../../scripts/md1/run.pbs"
LOC_com_md="../../scripts/md1/com_md"

if [ $NTEMP -gt 1 ]; then
    interval_temp=`echo "scale=3; (${H_SCALE_FACT}-${L_SCALE_FACT})/($NTEMP-1)" | bc`

elif [ $NTEMP -le 1 ]; then
    interval_temp=${H_SCALE_FACT}

else
    echo "NTEMP is too small."
    exit

fi
echo "Scale factor interval: ", $interval_temp

CDR=$(pwd)
echo "Current directory: " $CDR


cd md1
#Buid directories for each tempeature and prepare for inputs
factor=$L_SCALE_FACT
for iT in $(seq 1 $NTEMP); do
    mkdir $iT
    cd $iT
    echo "#Scale factor: " $factor
    cp $LOC_runpbs .  # each T dir has a run.pbs file
    cp $LOC_com_md .

    gpuid=0
    for irun in $(seq 1 $NRUNS); do
        if [ $gpuid -ge 4 ]; then
            echo "WARNING: GPU id is greater than 4."
            exit
        fi

        mkdir n$irun
        cd n$irun
        printf "  *In "; pwd

        echo "    Making input files in each directries, n1 n2..."
        cp  $TMPL_syscfg system.cfg
        cat $TMPL_ttpinp | sed -e "s!#{FORCE_COEF}!${factor}!g"> ttp_v_mcmd.inp
        cat $TMPL_mdrun  | sed -e "s!#{GPU_DEVICE_ID}!${gpuid}!g"> md.inp

        { echo 1; echo $RANDOM; } > start.vert

        echo "    Copying the initial structure into each directory"
        DirSavingInitPDBs=../../../sample/initials
        PDBPickedRandomly=`ls ${DirSavingInitPDBs} | grep pdb | sort -R | head -1`
        InitPDBName=init.pdb
        echo "       ${DirSavingInitPDBs%/}/${PDBPickedRandomly} => ${InitPDBName}"
        cp ${DirSavingInitPDBs%/}/${PDBPickedRandomly} ${InitPDBName}

        echo "    Making initial restart file"
        top=../../../inputs/system.tpl
        shk=../../../inputs/system.shk
        T=300
        python2.7 ${OMGTK}/presto_generate_velocities.py \
               -i  ${InitPDBName} \
               --i-tpl $top \
               --i-shk $shk \
               -t $T          \
               -s $RANDOM      \
               -o init.rst \
               --mol --check > init_velo.log

        echo "    Making the binary file, .cls, as an input of omeganene"
        python2.7 ${OMGTK}/mdinput_generator.py -i system.cfg -o md.cls -v v.0.39.h > mdinpgen.out

        gpuid=`expr $gpuid + 1`
        cd ..
    done
    factor=`echo "$factor+$interval_temp" | bc`
    cd ..
done
