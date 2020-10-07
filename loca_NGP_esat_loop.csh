#!/bin/bash


## ETCCDI https://code.mpimet.mpg.de/projects/cdo/embedded/cdo_eca.pdf

OS_NAME=`uname`
HOST_NAME=`hostname`


  echo Working on ${HOST_NAME} using ${OS_NAME}

  declare -a    PARAM=(  "tasmin" "tasmax" )

  declare -a NEWPARAM=( "esmax", "esmin")
  declare -a SCENARIO=( "historical" "rcp85" "rcp45" )

  declare -a SCENARIO=( "historical" )
  declare -a    PARAM=(  "tasmin"  )


  # setting the Setting the Available ensembles
  #   currently only those members that have hits
  #   for all three variables!

  declare -a ENSEMBLE=(   "ACCESS1-0_r1i1p1"
                          "ACCESS1-3_r1i1p1"
                          "CCSM4_r6i1p1"
                          "CESM1-BGC_r1i1p1"
                          "CESM1-CAM5_r1i1p1"
                          "CMCC-CMS_r1i1p1"
                          "CMCC-CM_r1i1p1"
                          "CNRM-CM5_r1i1p1"
                          "CSIRO-Mk3-6-0_r1i1p1"
                          "CanESM2_r1i1p1"
                          "FGOALS-g2_r1i1p1"
                          "GFDL-CM3_r1i1p1"
                          "GFDL-ESM2G_r1i1p1"
                          "GFDL-ESM2M_r1i1p1"
                          "HadGEM2-AO_r1i1p1"
                          "HadGEM2-CC_r1i1p1"
                          "HadGEM2-ES_r1i1p1"
                          "IPSL-CM5A-LR_r1i1p1"
                          "IPSL-CM5A-MR_r1i1p1"
                          "MIROC-ESM-CHEM_r1i1p1"
                          "MIROC-ESM_r1i1p1"
                          "MIROC5_r1i1p1"
                          "MPI-ESM-LR_r1i1p1"
                          "MPI-ESM-MR_r1i1p1"
                          "MRI-CGCM3_r1i1p1"
                          "NorESM1-M_r1i1p1"
                          "bcc-csm1-1-m_r1i1p1" )

                          declare -a ENSEMBLE=(   "ACCESS1-0_r1i1p1" )



   export       DATASET="LOCA_NGP"
   export DATASETPREFIX="NGP_LOCA"

   export CLIPPED_INDIR_ROOT="/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/Northern_Great_Plains_Original_Subset"





   # setting the available variables



   export ENS=${ENSEMBLE[0]}
   export PAR=${PARAM[0]}
   export PTILE=${PERCENTILE[9]}
   export SCEN=${SCENARIO[0]}

for SCEN in "${SCENARIO[@]}"
do




     for ENS in "${ENSEMBLE[@]}"
     do
        echo =============================================================
        echo


        for PAR in "${PARAM[@]}"
        do

           if [[ PAR == "tasmax" ]]  ; then
             export NEWPAR="esatmax"
           else
             export NEWPAR="esatmin"
           fi

           echo
           echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           echo

           export CLIPPED_INDIR=${CLIPPED_INDIR_ROOT}/${SCEN}/${PAR}

           echo processing $CLIPPED_INPREFIX

           export   CLIPPED_OUTDIR=${CLIPPED_INDIR_ROOT}/derived/${SCEN}/${NEWPAR}

           echo mkdir -p ${CLIPPED_OUTDIR}

           export INVAR=${PAR}_${ENS}_${SCEN}
           export OUTVAR=${NEWPAR}_${ENS}_${SCEN}

           export INFILE=${CLIPPED_INDIR}/NGP_LOCA_${PAR}_${ENS}_${SCEN}.nc
           export OUTFILE=${CLIPPED_OUTDIR}/NGP_LOCA_${NEWPAR}_${ENS}_${SCEN}.nc
           export TEMPFILE=./temp_${NEWPAR}_${ENS}_${SCEN}.nc

           echo ${INFILE}
           echo ${OUTFILE}

           echo

           echo ncrename -h -v ${INVAR},temporary ${INFILE} ${OUTFILE}
           # echo nohup ncap2 --history --script 'where(temporary != 0) temporary=6.11 * exp((2.5e6 / 461) * (1 / 273 - 1 / (273.15 + temporary)))' ${OUTFILE} ${TEMPFILE}
           echo nohup ncap2 --history --script 'where(temporary != 0) temporary=temporary+5.0' ${OUTFILE} ${TEMPFILE}

           echo ncrename -h -v temporary,${OUTVAR} ${TEMPFILE} ${OUTFILE}

           echo rm -frv ${TEMPFILE}



        done #parameter
        echo

  done  # ensemble
  echo
done #scenario



echo "We're Out of Here Like Vladimir"
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
