#!/bin/bash


### NCL COMMANDS TO FETCH GRIDCELLS BY LAT/LON
#  f = addfile("http://kyrill.ias.sdsmt.edu:8080/thredds/dodsC/LOCA_NGP/Northern_Great_Plains_Original_Subset/historical/pr/NGP_LOCA_pr_ACCESS1-0_r1i1p1_historical.nc","r")
#
#  lon = f->lon
#  lat = f->lat
#
#   min_lat =  42.65625 ; degrees north
#   max_lat =  45.21875 ; degrees north

#   min_lon = -106.0938 ; degrees east
#   max_lon = -101.2188 ; degrees east
#
# deg_target = lon({max_lon})
# index_xx = ind(lon .eq. lon({max_lon}))
# index_xn = ind(lon .eq. lon({min_lon}))
# index_yx = ind(lat .eq. lat({max_lat}))
# index_yn = ind(lat .eq. lat({min_lat}))
# print("LONCLIP=  [" +  (index_xn) + ":1:" + (index_xx) + "] [" +  (lon(index_xn)-360) + ":1:" + (lon(index_xx)-360) + "]")
# print("LATCLIP=  [" +  (index_yn) + ":1:" + (index_yx) + "] [" +  lat(index_yn) + ":1:" + lat(index_yx) + "]")
#
#
##################

OS_NAME=`uname`
HOST_NAME=`hostname`

#CHeyenne
export LONCLIP="[131:1:209]"  # [-114.28125 : 1 : -86.28125]
export LATCLIP="[139:1:180]"  # [  33.96875 : 1 :  52.71875]


  echo Working on ${HOST_NAME} using ${OS_NAME}

  declare -a    PARAM=(  "tasmin" "tasmax" )

  declare -a NEWPARAM=( "esmax", "esmin")
  declare -a SCENARIO=( "historical" "rcp85" "rcp45" )

  declare -a SCENARIO=( "historical" )
  declare -a    PARAM=(  "tasmax"  )


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

     if [[ SCEN == "historical" ]]  ; then
       export TIMECORDS=[0:1:20453]
     else
       export TIMECORDS=[0:1:34332]
     fi




     export TYX_COORDS=${TIMECORDS}${LATCLIP}${LONCLIP}

     export ALWAYS_GET_US=lon${LONCLIP},lon_bnds${LONCLIP}[0:1:1],lat${LATCLIP},lat_bnds${LATCLIP}[0:1:1],time${TIMECORDS},time_bnds${TIMECORDS}[0:1:1]




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
           export OUTFILE=${CLIPPED_OUTDIR}/CHEYENNE_LOCA_${NEWPAR}_${ENS}_${SCEN}.nc
           export TEMPFILE=./temp_${NEWPAR}_${ENS}_${SCEN}.nc
           export TEMPFILESHORT=./temp_${NEWPAR}_${ENS}_${SCEN}_short.nc
           export TEMPFILEVAP=./temp_${NEWPAR}_${ENS}_${SCEN}_es.nc

           ls -al ${INFILE}
           ls -al ${OUTFILE}

           echo

           rm -frv ${TEMPFILE}
           rm -frv ${TEMPFILE}
           rm -frv ${TEMPFILESHORT}
           rm -frv ${OUTFILE}

           echo nccopy -4 -d 8 ${INFILE}?${ALWAYS_GET_US},${INVAR}${TYX_COORDS}  ${TEMPFILE}
          nohup nccopy -4 -d 8 ${INFILE}?${ALWAYS_GET_US},${INVAR}${TYX_COORDS}  ${TEMPFILE} 


           ncrename -O -h -v ${INVAR},temporary  ${TEMPFILE}
           ncatted -h -O -a units,temporary,m,c,"Pa" ${TEMPFILE}
           ncatted -h -O -a scale_factor,temporary,m,f,1.0  ${TEMPFILE}
           ncatted -h -O -a standard_name,temporary,m,c,"water_vapor_partial_pressure_in_air_at_saturation"  ${TEMPFILE}

           if [[ PAR == "tasmax" ]]  ; then
             ncatted -h -O -a long_name,temporary,m,c,"Maximum Daily Equilibrium Vapor Pressure"  ${TEMPFILE}
             ncatted -h -O -a description,temporary,m,c,"Maximum Daily Equilibrium Vapor Pressure"  ${TEMPFILE}
           else
             ncatted -h -O -a long_name,temporary,m,c,"Minimum Daily Equilibrium Vapor Pressure"  ${TEMPFILE}
             ncatted -h -O -a description,temporary,m,c,"Minimum Daily Equilibrium Vapor Pressure"  ${TEMPFILE}
           fi

          nohup ncap2 --history  --script 'where(temporary > 0)  temporary=short(round( 611. * exp((2.5e6 / 461) * (1 / 273 - 1 / (273.15 + temporary*10.))) ))'  ${TEMPFILE}  ${OUTFILE}

          ncrename -O -h -v temporary,${OUTVAR}  ${OUTFILE}

          rm -frv ${TEMPFILE}
          rm -frv ${TEMPFILESHORT}


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
