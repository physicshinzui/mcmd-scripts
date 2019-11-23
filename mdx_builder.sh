#/bin/bash

set -Ceu

build_mdx_dir() {
  local iter=$1
  local Nruns=$2
  if [ ! -e "md${iter}" ]; then
    mkdir md${iter}
    for i in $(seq 1 $Nruns); do
      mkdir -p md${iter}/n${i}
    done
  elif [ -e "md${iter}" ]; then
    echo "md${iter} exists."
    exit

  fi
}

arrange_mdinp(){
  template_mdinp="md.inp.run"
  cat ${TMP_Path%/}/${template_mdinp} | sed -e "s!#{GPU_DEVICE_ID}!${GpuId}!g" #> md.inp
}
arrange_system_cfg(){
  template_system_cfg="system_base.cfg"
  cat ${TMP_Path%/}/${template_system_cfg} |            \
      sed -e "s!#{TPL_FILE}!${TPL_FILE}!g"              \
          -e "s!#{INITIAL_PDB}!${INITIAL_PDB}!g"        \
          -e "s!#{SHK_FILE}!${SHK_FILE}!g"              \
          -e "s!#{ATOM_GROUP_FILE}!${ATOM_GROUP_FILE}!g"\
          -e "s!#{DISRES_FILE}!${DISRES_FILE}!g"        \
          -e "s!#{RESTART_FILE}!${RESTART_FILE}!g"
}

put_inputs(){
  local GpuId=0
  printf "Put inputs in :"
  for nx in ${List_dir}; do
     printf "  $nx"

    #***Move md.inp
    arrange_mdinp > md.inp
    mv md.inp ${WORK_DIR%/}/md${Iter}/${nx}
    GpuId=`expr $GpuId + 1`
    if [ ${GpuId} -gt 2 ]; then GpuId=0; fi

    #***cp system.cfg
    arrange_system_cfg > system.cfg
    mv system.cfg ${WORK_DIR%/}/md${Iter}/${nx}

    #***move job scripts

  done
  cd ${WORK_DIR%/}/src_job_scripts
  bash ${WORK_DIR%/}/src_job_scripts/make_job_cript.bash
  mv  ${WORK_DIR%/}/src_job_scripts/job_* ${WORK_DIR%/}/md${Iter}
  cp  ${WORK_DIR%/}/src_job_scripts/com_md ${WORK_DIR%/}/md${Iter}
  cd ..
  echo
}

#----Main----
#***REad param_mdx.inp
nlines=`wc -l param_mdx.inp | awk '{print $1}'`
echo $nlines
for i in $(seq 1 $nlines); do
  read key value
  if [ $key == "--work-dir" ]           ; then { WORK_DIR=$value       ; echo "Work dir: " $WORK_DIR; }; fi
  if [ $key == "--iteration-no" ]       ; then { Iter=$value           ; echo "Iteration no: " $Iter; }; fi
  if [ $key == "--no-of-paralell-runs" ]; then { Nruns=$value          ; echo "No of paralell runs: " $Nruns;}; fi
  if [ $key == "--path-of-templates" ]  ; then { TMP_Path=$value       ; echo "path-of-templates:" $TMP_Path;  }; fi
  if [ $key == "--tpl-file" ]           ; then { TPL_FILE=$value       ; echo "tpl-file:" $TPL_FILE ; }; fi
  if [ $key == "--shk-file" ]           ; then { SHK_FILE=$value       ; echo "shk-file:" $SHK_FILE ; }; fi
  if [ $key == "--init-pdb" ]           ; then { INITIAL_PDB=$value    ; echo "init-pdb:" $INITIAL_PDB ; }; fi
  if [ $key == "--i-restart" ]          ; then { RESTART_FILE=$value   ; echo "restart file:" $RESTART_FILE ; }; fi
  if [ $key == "--atom-group-file" ]    ; then { ATOM_GROUP_FILE=$value; echo "atom-group-file:" $ATOM_GROUP_FILE ; }; fi
  if [ $key == "--disres-file" ]        ; then { DISRES_FILE=$value    ; echo "disres-file:" $DISRES_FILE ; }; fi
done

#(1)
build_mdx_dir $Iter $Nruns
List_dir=`ls -v md${Iter}`  #n1 n2 n3 ...
echo "nx directories: " $List_dir

#(2)
put_inputs

#(3) Copy ttp_v_mcmd.inp into mdx
#@@@shoud be inupted
#ttp="tools_forPrepBySinzi/for_next/range_make/ttp_v_mcmd.inp"
#[ -e $ttp ] && cp -r $ttp md${Iter}

#(3) Put scripts for generation of start.vert
cp -r ${WORK_DIR%/}/scripts/mdx/make_start_v_reset ${WORK_DIR%/}/md${Iter}
cp -r ${WORK_DIR%/}/scripts/mdx/sed_restart.bash ${WORK_DIR%/}/md${Iter}
echo "Please execute 4_set_vert in make_start_v_reset after finishing this script."
