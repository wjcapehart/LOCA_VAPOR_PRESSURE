#!/bin/bash


OS_NAME=`uname`
HOST_NAME=`hostname`

TEST_STRING=`nccopy https://cida.usgs.gov/thredds/dodsC/loca_future?lat[0:1:489] deleteme.nc`

echo ****************
echo ** Test String ||$TEST_STRING|| **
echo *****************

if [[ "$OS_NAME" == 'Darwin' ]];
then
   source ~wjc/.bash_profile
fi


if [ -z "$TEST_STRING" ];
then
  rm -frv deleteme.nc
  echo Working on ${HOST_NAME} using ${OS_NAME}

   declare -a    PARAM=(  "pr"         "tasmin" "tasmax" )
   declare -a SCENARIO=(  "historical" "rcp85"  "rcp45"  )


   ### NCL COMMANDS TO FETCH GRIDCELLS BY LAT/LON
   #
   #   max_lat =  52.75 ; degrees north
   #   min_lat =  34.00 ; degrees north
   #   min_lon = -114.25 + 360 ; degrees east
   #   max_lon =  -86.25 + 360 ; degrees east
   #
   #  deg_target = lon({max_lon})
   # index_xx = ind(lon .eq. lon({max_lon}))
   #  index_xn = ind(lon .eq. lon({min_lon}))
   #  index_yx = ind(lat .eq. lat({max_lat}))
   #  index_yn = ind(lat .eq. lat({min_lat}))
   #  print("LONCLIP=  [" +  (index_xn) + ":1:" + (index_xx) + "] [" +  (lon(index_xn)-360) + ":1:" + (lon(index_xx)-360) + "]")
   #  print("LATCLIP=  [" +  (index_yn) + ":1:" + (index_yx) + "] [" +  lat(index_yn) + ":1:" + lat(index_yx) + "]")
   #
   #
   ##################



   ### NGP
   export LONCLIP="[187:1:636]"  # [-114.28125 : 1 : -86.28125]
   export LATCLIP="[169:1:470]"  # [  33.96875 : 1 :  52.71875]

   export NCCOPY="nccopy"

   # CIDA THREDDS Address for both Historical and Future Scenarios

   export     FUTURE_ORIGINAL_URL="https://cida.usgs.gov/thredds/dodsC/loca_future"
   export HISTORICAL_ORIGINAL_URL="https://cida.usgs.gov/thredds/dodsC/loca_historical"

   # Setting Local Points to Revieved Clipped Data

   export CLIPPED_WORKDIR="/projects/ECEP/LOCA_MACA_Ensembles/LOCA/LOCA_OUTPUT/grid_ngp"
   mkdir -vp ${CLIPPED_WORKDIR}

   export CLIPPED_PREFIX=${CLIPPED_WORKDIR}"/NGP_LOCA"

   # setting the CIDA THREDDS Address
   ####################################################################
   #  Threds  CIDA Time By Year (Histoprical)
   #f = addfile("https://cida.usgs.gov/thredds/dodsC/loca_historical","r")
   # f = addfile("https://cida.usgs.gov/thredds/dodsC/loca_future","r")

#  time= f->time
#   starty = 1950
#   endy   = 2005
#   starty = 2006
#   endy   = 2099
#         ny    = endy-starty + 1
#         time_3d = cd_calendar(time,-5)
#         time_year = time_3d(:,0)
#         year_coord = ispan(starty,endy,1)
#         year_start  = new(ny,"integer")
#         year_end  = new(ny,"integer")
#
#         do y = 0,ny-1
#            year_start(y) = min(ind(time_year.eq.year_coord(y)))
#            year_end(y)   = max(ind(time_year.eq.year_coord(y)))
#            print(","+y+", T"+year_coord(y)+",["+sprinti("%0.5d",year_start(y))+":1:"+sprinti("%0.5d",year_end(y))+"]")
#         end do
#    ###########################################################################




   # setting the Setting the Available ensembles
   #   currently only those members that have hits
   #   for all three variables!

     declare -a ENSEMBLE=( "ACCESS1-0_r1i1p1"
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


   # setting the available variables

    declare -a PASSES=(  "1"
                         "2"
                         "3"
                         "4" )

   for PASS in  "${PASSES[@]}"
   do

      bad_curl=0

      echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      echo
      for SCEN in "${SCENARIO[@]}"
      do

         if [ ${SCEN} == "historical" ]
         then
            export ORIGINAL_URL=${HISTORICAL_ORIGINAL_URL}

            declare -a TIND_VALS=(  0
                                    1
                                    2
                                    3
                                    4
                                    5
                                    6
                                    7
                                    8
                                    9
                                    10
                                    11
                                    12
                                    13
                                    14
                                    15
                                    16
                                    17
                                    18
                                    19
                                    20
                                    21
                                    22
                                    23
                                    24
                                    25
                                    26
                                    27
                                    28
                                    29
                                    30
                                    31
                                    32
                                    33
                                    34
                                    35
                                    36
                                    37
                                    38
                                    39
                                    40
                                    41
                                    42
                                    43
                                    44
                                    45
                                    46
                                    47
                                    48
                                    49
                                    50
                                    51
                                    52
                                    53
                                    54
                                    55 )

         declare -a TIMECLIPCODE=(   __T1950
                                     __T1951
                                     __T1952
                                     __T1953
                                     __T1954
                                     __T1955
                                     __T1956
                                     __T1957
                                     __T1958
                                     __T1959
                                     __T1960
                                     __T1961
                                     __T1962
                                     __T1963
                                     __T1964
                                     __T1965
                                     __T1966
                                     __T1967
                                     __T1968
                                     __T1969
                                     __T1970
                                     __T1971
                                     __T1972
                                     __T1973
                                     __T1974
                                     __T1975
                                     __T1976
                                     __T1977
                                     __T1978
                                     __T1979
                                     __T1980
                                     __T1981
                                     __T1982
                                     __T1983
                                     __T1984
                                     __T1985
                                     __T1986
                                     __T1987
                                     __T1988
                                     __T1989
                                     __T1990
                                     __T1991
                                     __T1992
                                     __T1993
                                     __T1994
                                     __T1995
                                     __T1996
                                     __T1997
                                     __T1998
                                     __T1999
                                     __T2000
                                     __T2001
                                     __T2002
                                     __T2003
                                     __T2004
                                     __T2005 )


            declare -a TIMECLIP=(   [00000:1:00364]
                                    [00365:1:00729]
                                    [00730:1:01095]
                                    [01096:1:01460]
                                    [01461:1:01825]
                                    [01826:1:02190]
                                    [02191:1:02556]
                                    [02557:1:02921]
                                    [02922:1:03286]
                                    [03287:1:03651]
                                    [03652:1:04017]
                                    [04018:1:04382]
                                    [04383:1:04747]
                                    [04748:1:05112]
                                    [05113:1:05478]
                                    [05479:1:05843]
                                    [05844:1:06208]
                                    [06209:1:06573]
                                    [06574:1:06939]
                                    [06940:1:07304]
                                    [07305:1:07669]
                                    [07670:1:08034]
                                    [08035:1:08400]
                                    [08401:1:08765]
                                    [08766:1:09130]
                                    [09131:1:09495]
                                    [09496:1:09861]
                                    [09862:1:10226]
                                    [10227:1:10591]
                                    [10592:1:10956]
                                    [10957:1:11322]
                                    [11323:1:11687]
                                    [11688:1:12052]
                                    [12053:1:12417]
                                    [12418:1:12783]
                                    [12784:1:13148]
                                    [13149:1:13513]
                                    [13514:1:13878]
                                    [13879:1:14244]
                                    [14245:1:14609]
                                    [14610:1:14974]
                                    [14975:1:15339]
                                    [15340:1:15705]
                                    [15706:1:16070]
                                    [16071:1:16435]
                                    [16436:1:16800]
                                    [16801:1:17166]
                                    [17167:1:17531]
                                    [17532:1:17896]
                                    [17897:1:18261]
                                    [18262:1:18627]
                                    [18628:1:18992]
                                    [18993:1:19357]
                                    [19358:1:19722]
                                    [19723:1:20088]
                                    [20089:1:20453])


         else
            export ORIGINAL_URL=${FUTURE_ORIGINAL_URL}
            declare -a TIND_VALS=(  0
                                    1
                                    2
                                    3
                                    4
                                    5
                                    6
                                    7
                                    8
                                    9
                                    10
                                    11
                                    12
                                    13
                                    14
                                    15
                                    16
                                    17
                                    18
                                    19
                                    20
                                    21
                                    22
                                    23
                                    24
                                    25
                                    26
                                    27
                                    28
                                    29
                                    30
                                    31
                                    32
                                    33
                                    34
                                    35
                                    36
                                    37
                                    38
                                    39
                                    40
                                    41
                                    42
                                    43
                                    44
                                    45
                                    46
                                    47
                                    48
                                    49
                                    50
                                    51
                                    52
                                    53
                                    54
                                    55
                                    56
                                    57
                                    58
                                    59
                                    60
                                    61
                                    62
                                    63
                                    64
                                    65
                                    66
                                    67
                                    68
                                    69
                                    70
                                    71
                                    72
                                    73
                                    74
                                    75
                                    76
                                    77
                                    78
                                    79
                                    80
                                    81
                                    82
                                    83
                                    84
                                    85
                                    86
                                    87
                                    88
                                    89
                                    90
                                    91
                                    92
                                    93 )


         declare -a TIMECLIPCODE=(   __T2006
                                     __T2007
                                     __T2008
                                     __T2009
                                     __T2010
                                     __T2011
                                     __T2012
                                     __T2013
                                     __T2014
                                     __T2015
                                     __T2016
                                     __T2017
                                     __T2018
                                     __T2019
                                     __T2020
                                     __T2021
                                     __T2022
                                     __T2023
                                     __T2024
                                     __T2025
                                     __T2026
                                     __T2027
                                     __T2028
                                     __T2029
                                     __T2030
                                     __T2031
                                     __T2032
                                     __T2033
                                     __T2034
                                     __T2035
                                     __T2036
                                     __T2037
                                     __T2038
                                     __T2039
                                     __T2040
                                     __T2041
                                     __T2042
                                     __T2043
                                     __T2044
                                     __T2045
                                     __T2046
                                     __T2047
                                     __T2048
                                     __T2049
                                     __T2050
                                     __T2051
                                     __T2052
                                     __T2053
                                     __T2054
                                     __T2055
                                     __T2056
                                     __T2057
                                     __T2058
                                     __T2059
                                     __T2060
                                     __T2061
                                     __T2062
                                     __T2063
                                     __T2064
                                     __T2065
                                     __T2066
                                     __T2067
                                     __T2068
                                     __T2069
                                     __T2070
                                     __T2071
                                     __T2072
                                     __T2073
                                     __T2074
                                     __T2075
                                     __T2076
                                     __T2077
                                     __T2078
                                     __T2079
                                     __T2080
                                     __T2081
                                     __T2082
                                     __T2083
                                     __T2084
                                     __T2085
                                     __T2086
                                     __T2087
                                     __T2088
                                     __T2089
                                     __T2090
                                     __T2091
                                     __T2092
                                     __T2093
                                     __T2094
                                     __T2095
                                     __T2096
                                     __T2097
                                     __T2098
                                     __T2099  )



          declare -a TIMECLIP=(  [00000:1:00364]
                                 [00365:1:00729]
                                 [00730:1:01095]
                                 [01096:1:01460]
                                 [01461:1:01825]
                                 [01826:1:02190]
                                 [02191:1:02556]
                                 [02557:1:02921]
                                 [02922:1:03286]
                                 [03287:1:03651]
                                 [03652:1:04017]
                                 [04018:1:04382]
                                 [04383:1:04747]
                                 [04748:1:05112]
                                 [05113:1:05478]
                                 [05479:1:05843]
                                 [05844:1:06208]
                                 [06209:1:06573]
                                 [06574:1:06939]
                                 [06940:1:07304]
                                 [07305:1:07669]
                                 [07670:1:08034]
                                 [08035:1:08400]
                                 [08401:1:08765]
                                 [08766:1:09130]
                                 [09131:1:09495]
                                 [09496:1:09861]
                                 [09862:1:10226]
                                 [10227:1:10591]
                                 [10592:1:10956]
                                 [10957:1:11322]
                                 [11323:1:11687]
                                 [11688:1:12052]
                                 [12053:1:12417]
                                 [12418:1:12783]
                                 [12784:1:13148]
                                 [13149:1:13513]
                                 [13514:1:13878]
                                 [13879:1:14244]
                                 [14245:1:14609]
                                 [14610:1:14974]
                                 [14975:1:15339]
                                 [15340:1:15705]
                                 [15706:1:16070]
                                 [16071:1:16435]
                                 [16436:1:16800]
                                 [16801:1:17166]
                                 [17167:1:17531]
                                 [17532:1:17896]
                                 [17897:1:18261]
                                 [18262:1:18627]
                                 [18628:1:18992]
                                 [18993:1:19357]
                                 [19358:1:19722]
                                 [19723:1:20088]
                                 [20089:1:20453]
                                 [20454:1:20818]
                                 [20819:1:21183]
                                 [21184:1:21549]
                                 [21550:1:21914]
                                 [21915:1:22279]
                                 [22280:1:22644]
                                 [22645:1:23010]
                                 [23011:1:23375]
                                 [23376:1:23740]
                                 [23741:1:24105]
                                 [24106:1:24471]
                                 [24472:1:24836]
                                 [24837:1:25201]
                                 [25202:1:25566]
                                 [25567:1:25932]
                                 [25933:1:26297]
                                 [26298:1:26662]
                                 [26663:1:27027]
                                 [27028:1:27393]
                                 [27394:1:27758]
                                 [27759:1:28123]
                                 [28124:1:28488]
                                 [28489:1:28854]
                                 [28855:1:29219]
                                 [29220:1:29584]
                                 [29585:1:29949]
                                 [29950:1:30315]
                                 [30316:1:30680]
                                 [30681:1:31045]
                                 [31046:1:31410]
                                 [31411:1:31776]
                                 [31777:1:32141]
                                 [32142:1:32506]
                                 [32507:1:32871]
                                 [32872:1:33237]
                                 [33238:1:33602]
                                 [33603:1:33967]
                                 [33968:1:34332] )


         fi

         echo ${TIND_VALS}
         for PAR in "${PARAM[@]}"
         do

            for ENS in "${ENSEMBLE[@]}"
            do
               echo --------------------------------------
               echo
               echo Processing ${PAR}_${ENS}_${SCEN}
               echo

               for TIND in "${TIND_VALS[@]}"
               do

                  export FILENAME=${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                  export  VARNAME=${PAR}_${ENS}_${SCEN}

                  mkdir -pv /projects/ECEP/LOCA_MACA_Ensembles/LOCA/LOCA_OUTPUT/graphics/${VARNAME}

                  ncl -Q -n file_name='"'${FILENAME}'"' variable_name='"'${VARNAME}'"'  vartype='"'${PAR}'"' macaloca_scan_and_check.ncl

                  if [ ! -f ${FILENAME} ]; then
                     echo missing ${FILENAME}
                     echo

                     export TYX_COORDS=${TIMECLIP[${TIND}]}${LATCLIP}${LONCLIP}

                     export ALWAYS_GET_US=lon${LONCLIP},lon_bnds${LONCLIP}[0:1:1],lat${LATCLIP},lat_bnds${LATCLIP}[0:1:1],time${TIMECLIP[${TIND}]},time_bnds${TIMECLIP[${TIND}]}[0:1:1]
                     #  export ALWAYS_GET_US=lon${LONCLIP},lat${LATCLIP},time${TIMECLIP[${TIND}]}

                     rm  nccopy.log

                     echo  Downloading File from USGS THREDDS Server
                     echo
                     echo  nohup nccopy -7 -d 8 ${ORIGINAL_URL}?${ALWAYS_GET_US},${PAR}_${ENS}_${SCEN}${TYX_COORDS} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]} >& ./nccopy.log
                           nohup nccopy -7 -d 8 ${ORIGINAL_URL}?${ALWAYS_GET_US},${PAR}_${ENS}_${SCEN}${TYX_COORDS} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]} >& ./nccopy.log

                     if (  grep -iFq "CURL" ./nccopy.log )
                     then

                        echo "%%%%%%%%%%%%%%%%%%%%%% CURL FAILURE %%%%%%%%%%%%%%%%%%%%%%%%"
                        cat ./nccopy.log
                        rm  ./nccopy.log
                        echo
                        echo CURL-ERROR ON  ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}
                             rm -frv ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}
                        echo "%%%%%%%%%%%%%%%%%%%%%% CURL FAILURE %%%%%%%%%%%%%%%%%%%%%%%%"

                        bad_curl=$((1+bad_curl))

                     else

                       echo "No Detected Curl Errors"


                       rm  ./nccopy.log

                        echo
                        echo Converting Time to the Record Variable
                        echo
                        echo nohup ncks -h --mk_rec_dmn time  ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             nohup ncks -h --mk_rec_dmn time  ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                   rm -frv                    ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}

                        echo
                        echo  Removing Missing and History Attributes from our Varibale in prepration for masking.
                        echo
                        echo ncatted -h -O -a history,,d,,        ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             ncatted -h -O -a history,,d,,        ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                        echo
                        echo Unpack File -- it will be uniformly packed later for all variables
                        echo
                        echo  nohup ncpdq -h -U   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                              nohup ncpdq -h -U   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                              mv -fv                           temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                        echo
                        echo Destroy any previous unpacking unformation
                        echo
                        echo  nohup ncatted -h -O -a add_offset,,d,,   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                              nohup ncatted -h -O -a add_offset,,d,,   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                              mv -fv                                                temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                        echo  nohup ncatted -h -O -a scale_factor,,d,, ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                              nohup ncatted -h -O -a scale_factor,,d,, ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                              mv -fv                                                temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc


                        echo
                        echo Remove Missing Values
                        echo
                        echo ncatted -h -O -a missing_value,,d,,  ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             ncatted -h -O -a missing_value,,d,,  ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                        echo
                        echo Change _FillValue to -32767
                        echo
                        echo ncatted -h -O -a _FillValue,${VARNAME},m,s,-32767        ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             ncatted -h -O -a _FillValue,${VARNAME},m,s,-32767        ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             ncatted -h -O -a missing_value,${VARNAME},d,,    ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             ncatted -h -O -a missing_value,${VARNAME},c,s,-32767        ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                        echo
                        echo Applying Mask
                        echo
                        echo cdo div  ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ./mask.nc  ./masked.nc
                             cdo div  ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ./mask.nc  ./masked.nc
                        mv -v  ./masked.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc


                        echo
                        echo Patch Longitude and Longitude Bounds
                        echo
                        echo nohup ncap2 --overwrite --history --script 'where(lon>180) lon=lon-360' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             nohup ncap2 --overwrite --history --script 'where(lon>180) lon=lon-360' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             mv -fv                            temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                        echo
                        echo nohup ncap2 --overwrite --history --script 'where(lon_bnds>180) lon_bnds=lon_bnds-360' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             nohup ncap2 --overwrite --history --script 'where(lon_bnds>180) lon_bnds=lon_bnds-360' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             mv -fv                            temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                        # Getting the Units
                        UNITS=`ncdump -h ${FILENAME} | grep ${VARNAME}:units | sed '/.*\"\(.*\)\".*/ s//\1/g' `

                        # Getting the Fill Value
                        FILLVALUE=`ncdump -h ${FILENAME} | grep ${VARNAME}:_FillValue | sed  "s/.*= //;s/ .*//;s/s//" `

                        echo
                        echo Patching if needed for ${VARNAME} ${UNITS} ${FILLVALUE}
                        echo


                        if [ "${UNITS}" == "C" ];
                        then
                           echo needs to change the units name from C to degC
                           ncatted -h -O -a units,${VARNAME},m,c,"degC" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                        fi


                        if [ "${UNITS}" == "mm" ];
                        then
                           echo needs to change the units name from mm to kg m-2
                           ncatted -h -O -a units,${VARNAME},m,c,"kg m-2" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                        fi



                        if [ "${UNITS}" == "K" ];
                        then
                           echo needs to change the units name from K to degC
                           ncatted -h -O -a units,${VARNAME},m,c,"degC" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                           ncrename -h -v ${VARNAME},temporary ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                           echo nohup ncap2 --history --script 'where(temporary != 0) temporary=temporary-273.15' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                nohup ncap2 --history --script 'where(temporary != 0) temporary=temporary-273.15' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                mv -fv                            temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                           ncrename -h -v temporary,${VARNAME} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                        fi

                        if [ "${UNITS}" == "kg m-2 s-1" ];
                        then
                           echo needs to change the units name from kg m-2 s-1 to kg m-2
                           ncatted -h -O -a units,${VARNAME},m,c,"kg m-2" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                           ncrename -h -v ${VARNAME},temporary ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                           echo nohup ncap2 --history --script 'temporary=temporary*86400.' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                nohup ncap2 --history --script 'temporary=temporary*86400.' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                mv -fv                            temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncrename -h -v temporary,${VARNAME} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                        fi

                        if [ "${PAR}" ==  "pr" ];
                        then
                           echo Editing Attributes for ${PAR}
                           ncatted -h -O -a long_name,${VARNAME},m,c,"Total Daily Precipitation"   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a description,${VARNAME},c,c,"Total Daily Precipitation" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a standard_name,${VARNAME},c,c,"precipitation_amount"    ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a cell_methods,${VARNAME},c,c,"time: sum"                ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                           # Compress Everything to short 2-byte integer.  Range –32768 to 32767
                           echo
                           echo ncrename -h -v ${VARNAME},temporary ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                ncrename -h -v ${VARNAME},temporary ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo
                           echo ncap2 --history --deflate 8 --script 'temporary=short(round(temporary*10))' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}_short.nc
                                ncap2 --history --deflate 8 --script 'temporary=short(round(temporary*10))' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}_short.nc
                           mv -v ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}_short.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo
                           echo ncap2 --history --deflate 8 --script 'where(temporary < 0) temporary=short(-32767)' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}_fill.nc
                                ncap2 --history --deflate 8 --script 'where(temporary < 0) temporary=short(-32767)' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}_fill.nc
                           mv -v ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}_fill.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo
                           echo ncrename -h -v temporary,${VARNAME} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                ncrename -h -v temporary,${VARNAME} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo
                           echo ncatted -h -O -a add_offset,${VARNAME},c,f,0     ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                ncatted -h -O -a add_offset,${VARNAME},c,f,0     ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo ncatted -h -O -a scale_factor,${VARNAME},c,f,0.1 ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                ncatted -h -O -a scale_factor,${VARNAME},c,f,0.1 ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo
                        fi


                        if [ "${PAR}" ==  "tasmax" ];
                        then
                           echo Editing Attributes for ${PAR}
                           ncatted -h -O -a long_name,${VARNAME},m,c,"Maximum Daily Temperature" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a description,${VARNAME},c,c,"Maximum Daily Temperature" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a standard_name,${VARNAME},c,c,"air_temperature" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a cell_methods,${VARNAME},c,c,"time: maximum" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                           # Compress Everything to short 2-byte integer.  Range –32768 to 32767
                           echo
                           echo Preparing Compression for ${PAR}_${ENS}_${SCEN}
                           echo
                           echo ncrename -h -v ${VARNAME},temporary ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                ncrename -h -v ${VARNAME},temporary ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo
                           echo ncap2 --history --deflate 8 --script 'temporary=short(round(temporary*10))' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}_short.nc
                                ncap2 --history --deflate 8 --script 'temporary=short(round(temporary*10))' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}_short.nc
                           mv -v ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}_short.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo
                           echo ncrename -h -v temporary,${VARNAME} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                ncrename -h -v temporary,${VARNAME} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo
                           echo ncatted -h -O -a add_offset,${VARNAME},c,f,0     ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                ncatted -h -O -a add_offset,${VARNAME},c,f,0     ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo ncatted -h -O -a scale_factor,${VARNAME},c,f,0.1 ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                ncatted -h -O -a scale_factor,${VARNAME},c,f,0.1 ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo
                        fi

                        if [ "${PAR}" ==  "tasmin" ];
                        then
                           echo Editing Attributes for ${PAR}
                           ncatted -h -O -a long_name,${VARNAME},m,c,"Minimium Daily Temperature" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a description,${VARNAME},c,c,"Minimium Daily Temperature" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a standard_name,${VARNAME},c,c,"air_temperature" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a cell_methods,${VARNAME},c,c,"time: minimum" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo

                           # Compress Everything to short 2-byte integer.  Range –32768 to 32767

                           echo Compressing for ${PAR}_${ENS}_${SCEN} to nearest 0.1 K
                           echo
                           echo ncrename -h -v ${VARNAME},temporary ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                ncrename -h -v ${VARNAME},temporary ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo
                           echo ncap2 --history --deflate 8 --script 'temporary=short(round(temporary*10))' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}_short.nc
                                ncap2 --history --deflate 8 --script 'temporary=short(round(temporary*10))' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}_short.nc
                           mv -v ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}_short.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo
                           echo ncrename -h -v temporary,${VARNAME} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                ncrename -h -v temporary,${VARNAME} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo
                           echo ncatted -h -O -a add_offset,${VARNAME},c,f,0     ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                ncatted -h -O -a add_offset,${VARNAME},c,f,0     ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo ncatted -h -O -a scale_factor,${VARNAME},c,f,0.1 ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                                ncatted -h -O -a scale_factor,${VARNAME},c,f,0.1 ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           echo
                        fi



                           # Get rid of the mess in the global Attributes
                           echo
                           echo Cleaning Global Attributes
                           echo
                           ncatted -h -O -a "(\.*).history",global,d,,       ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a "(\.*).units",global,d,,         ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a "(\.*)._FillValue",global,d,,    ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a "(\.*)._ChunkSizes",global,d,,   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a "(\.*).long_name",global,d,,     ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a "(\.*).missing_value",global,d,, ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a "(\.*).scale_factor",global,d,,  ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a "(\.*).offset_value",global,d,,  ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           ncatted -h -O -a missing_value,${VARNAME},m,s,-32767     ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                    fi

                 fi
                 echo
                 echo --------------------------------------
                 echo

               done
               echo
               echo ======================================
               echo
            done
         done
         echo ======================================
         echo ======================================
         echo ======================================
         echo ======================================
         echo ======================================
         echo ======================================
         echo
      done

      echo $PASS COMPLETE
      echo PASS $PASS CURL-ERROR Count = $bad_curl
   done

else

   echo This Script Is Not Compatable with this Machine ${HOST_NAME} using ${OS_NAME}

fi


echo "We're Out of Here Like Vladimir"
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
