#!/bin/bash

wave_dir=${GINA300_DATA_ROOT}/waves

let subset=1
while read line
do 
	if [ ${subset} -gt ${CORPUS_SUBSET} ]; then
		break;
	else
		let subset=${subset}+1
	fi
	echo "$line $wave_dir/$line.wav"
done < ${DATA_LOCAL_DIR}/waves_all.list
