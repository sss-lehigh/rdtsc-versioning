#! /bin/bash

if [[ $# -ne 3 ]]; then
  echo "Incorrect number of arguments (expected=4, actual=$#)."
  echo "Usage: $0 <datadir> <num_trials> <listname>."
  exit
fi

datadir=$1
ntrials=$2
listname=$3
# Each algorithm should be isolated in its own directory.
algos=$(ls ${datadir})
echo "ALGOS"
echo $algos

cd ${datadir}
outfile=${listname}.csv
echo "OUTFILE"
echo ${outfile}

currfile=""
rqthrupt=0
uthrupt=0
totthrupt=0
ulat=0
clat=0
rqlat=0
rqthrupt=0
uthrupt=0
totthrupt=0
track_thrupt=()
avgrqlen=0
avgannounce=0
avgbag=0
reachable=0
avgbundle=0
trialcount=0
samplecount=0
nobundlestats=0
restarts=0
avgretries=0
avgtraversals=0
echo "list,max_key,u_rate,rq_rate,wrk_threads,rq_threads,rq_size,ts,u_latency,c_latency,rq_latency,tot_thruput,u_thruput,c_thruput,rq_thruput,rq_len,avg_in_announce,avg_in_bags,reachable_nodes,avg_bundle_size,tot_restarts,avg_retries,avg_traversals,std_dev" >${outfile}
for algo in ${algos}; do
  files=$(ls ${algo} | grep ${listname})
  for f in ${files}; do
    filename=${algo}/${f}
    # Only parse lines for given listname.
    if [[ "${listname}" != "" ]] && [[ "$(echo ${filename} | grep ${listname})" == "" ]]; then
      exit
    elif [[ "$(echo ${filename} | sed 's/.*[.]csv/.csv/')" == ".csv" ]]; then
      # Skip any generated .csv files.
      continue
    fi

    # Assumes trials are consecutive.
    rootname=$(echo ${filename} | sed -E 's/step[0-9]+[.]//' | sed -e 's/[.]trial.*//') # filename without "step37821" and "trialx.out" - EX: luigi.skiplistlock.bundle.ts.k1000000.u50.rq0.rqsize50.nrq0.nwork1
    ts=$(echo $rootname | awk -F'.' '{print $4}') # extract the timestamp
    if [[ "${ts}" == "rdtsc" ]]; then
      continue
    fi 

    if [[ ! "${rootname}" == "${currfile}" ]]; then
      trialcount=0
      samplecount=0
      currfile=${rootname}

      config=$(cat ${filename} | grep -B 10000 'BEGIN RUNNING')

      # Get name of list.
      list=$(echo ${filename} | sed -e "s/.*[.]${listname}[.]/${listname}-/" | sed -e 's/[.].*//') # ex: skiplistlock-bundle
      list+="-${ts}"
      rqstrategy=$(echo "${list}" | sed -e "s/.*-//")

      # Get maximum key.
      maxkey=$(echo "${config}" | grep 'MAXKEY=' | sed -e 's/.*=//')

      nwrkthrds=$(echo "${config}" | grep 'WORK_THREADS=' | sed -e 's/.*=//')
      irate=$(echo "${config}" | grep 'INS=' | sed -e 's/.*=//')
      rrate=$(echo "${config}" | grep 'DEL=' | sed -e 's/.*=//')
      urate=$(echo "${irate} + ${rrate}" | bc)
      rqsize=$(echo "${config}" | grep 'RQSIZE=' | sed -e 's/.*=//')
      rqrate=$(echo "${config}" | grep 'RQ=' | sed -e 's/.*=//')
      rqthrds=$(echo "${config}" | grep 'RQ_THREADS=' | sed -e 's/.*=//')
    fi

    trialcount=$((trialcount + 1))
    filecontents=$(cat ${filename} | grep -A 10000 'END RUNNING')
    if [[ $(echo "${filecontents}" | grep -c 'end delete ds') != 1 ]]; then
      # Skip if not a completed run.
      continue
    fi

    # Latency statistics.
    ulat=$(($(echo "${filecontents}" | grep 'average latency_updates' | sed -e 's/.*=//') + ${ulat}))
    clat=$(($(echo "${filecontents}" | grep 'average latency_searches' | sed -e 's/.*=//') + ${clat}))
    rqlat=$(($(echo "${filecontents}" | grep 'average latency_rqs' | sed -e 's/.*=//') + ${rqlat}))

    # Throughput statistics.
    rqthrupt=$(($(echo "${filecontents}" | grep 'rq throughput' | sed -e 's/.*: //') + ${rqthrupt}))
    uthrupt=$(($(echo "${filecontents}" | grep 'update throughput' | sed -e 's/.*: //') + ${uthrupt}))
    totthrupt=$(($(echo "${filecontents}" | grep 'total throughput' | sed -e 's/.*: //') + ${totthrupt}))
    tot_thpt_now=$(echo "${filecontents}" | grep 'total throughput' | sed -e 's/.*: //')
    track_thrupt+=(${tot_thpt_now})

    # Average range query length.
    avgrqlen=$(($(echo "${filecontents}" | grep 'average length_rqs' | sed -e 's/.*=//') + ${avgrqlen}))

    # EBR specific statistics.
    # if [[ "${nobundlestats}" == 0 ]] && ([[ "${rqstrategy}" == "lbundle" ]] || [[ "${rqstrategy}" == "cbundle" ]]); then
    # Bundle specific statistics.
    # reachable=$(($(echo "${filecontents}" | grep 'total reachable_nodes' | sed -e 's/.*: //') + ${reachable}))
    # if [[ ${reachable} != 0 ]]; then
    # avgbundle=$(echo "$(echo "${filecontents}" | grep 'average bundle_size' | sed -e 's/.*: //') + ${avgbundle}" | bc)
    # fi
    # else
    # if [[ "${avgbundle}" != "0" ]]; then
    #   exit 1
    # fi
    avgannounce=$(($(echo "${filecontents}" | grep 'average visited_in_announcements' | sed -e 's/.*=//') + ${avgannounce}))
    avgbag=$(($(echo "${filecontents}" | grep 'average visited_in_bags' | sed -e 's/.*=//') + ${avgbag}))
    # fi

    restarts=$(($(echo "${filecontents}" | grep 'sum bundle_restarts' | sed -e 's/.*=//') + ${restarts}))
    avgretries=$(($(echo "${filecontents}" | grep 'average bundle_retries' | sed -e 's/.*=//') + ${avgretries}))
    avgtraversals=$(($(echo "${filecontents}" | grep 'average bundle_traversals' | sed -e 's/.*=//') + ${avgtraversals}))

    samplecount=$((${samplecount} + 1))

    # Output previous averages.
    if [[ ${trialcount} == ${ntrials} ]]; then
      if [[ ${samplecount} != ${ntrials} ]]; then
        echo "Warning: unexpected number of samples (${samplecount}). Computing averages anyway: ${rootname}"
      elif [[ ${samplecount} == 0 ]]; then
        echo "Error: No samples collected: ${rootname}"
      else 
        printf "%s,%d,%.2f,%.2f,%d,%d,%d,%s" ${list} ${maxkey} ${urate} ${rqrate} ${nwrkthrds} ${rqthrds} ${rqsize} ${ts} >> ${outfile}
        printf ",%d" $((${ulat} / ${samplecount})) >>${outfile}
        printf ",%d" $((${clat} / ${samplecount})) >>${outfile}
        printf ",%d" $((${rqlat} / ${samplecount})) >>${outfile}
        printf ",%d" $((${totthrupt} / ${samplecount})) >>${outfile}
        printf ",%d" $((${uthrupt} / ${samplecount})) >>${outfile}
        printf ",%d" $((${totthrupt} - (${uthrupt} + ${rqthrupt}))) >>${outfile}
        printf ",%d" $((${rqthrupt} / ${samplecount})) >>${outfile}
        printf ",%d" $((${avgrqlen} / ${samplecount})) >>${outfile}
        printf ",%d" $((${avgannounce} / ${samplecount})) >>${outfile}
        printf ",%d" $((${avgbag} / ${samplecount})) >>${outfile}
        printf ",%d" $((${reachable} / ${samplecount})) >>${outfile}
        printf ",%.2f" $(echo "scale=4;$(echo ${avgbundle}) / ${samplecount}.0" | bc) >>${outfile}
        printf ",%d" $((${restarts} / ${samplecount})) >>${outfile}
        printf ",%d" $((${avgretries} / ${samplecount})) >>${outfile}
        printf ",%d" $((${avgtraversals} / ${samplecount})) >>${outfile}

        # calculate the standard deviation for the similar group of runs
        sum=0
        avg=$(bc -l <<< $totthrupt/$samplecount)
        for value in "${track_thrupt[@]}"
        do
          temp1=$(bc -l <<< $value-$avg)
          temp2=$(bc -l <<< $temp1*$temp1)
          sum=$(bc -l <<< $temp2+$sum)
        done
        variance=$(bc -l <<< $sum/$samplecount)
        std_dev=$(echo "$variance" | awk '{print sqrt($1)}')
        std_dev=$(echo ${std_dev} | awk -F"E" 'BEGIN{OFMT="%.2f"} {print $1 * (10 ^ $2)}')

        printf ",%.2f" $(echo "scale=4; ${std_dev}" | bc) >>${outfile}
        printf "\n" >>${outfile}

      fi

      ulat=0
      clat=0
      rqlat=0
      rqthrupt=0
      uthrupt=0
      totthrupt=0
      track_thrupt=()
      avgrqlen=0
      avgannounce=0
      avgbag=0
      reachable=0
      avgbundle=0
      restarts=0
      avgretries=0
      avgtraversals=0
    fi
  done
done
