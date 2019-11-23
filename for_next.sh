#!/bin/bash
set -e

export PROJ_DIR="/work1/t2g-16IAN/siida/02_s100b_ctd_work/"

cat scripts/mdx/current_situation
read -p "Ok? y/n: " yn
[ ${yn} = "y" ] && echo "current_situation remains."
[ ${yn} = "n" ] && vi scripts/mdx/current_situation
                       
cd scripts/mdx/v_distrib/
bash 1_make_v_distrib.bash

cd ../fit_pmc_entire/
{ csh 1_com; csh 2_com; csh 3_com; }

cd ../fit_mix/
{ csh 1_sinple_mix; csh 2_prep_refit; csh 3_refit; }

