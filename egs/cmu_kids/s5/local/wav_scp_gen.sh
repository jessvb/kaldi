#!/bin/bash 

# This script generate the wav.scp file

data_dir=${DATA_ROOT}/kids

if [ -f ${WAV_SCP_FILE} ]; then
	rm ${WAV_SCP_FILE}
fi

echo "Start generating wav.scp file."
let subset=1
while read line
do
	if [ ${subset} -gt ${CORPUS_SUBSET} ]; then
		break;
	else
		let subset=${subset}+1
	fi
	# <utterance-id>
	file_n=`echo ${line} | sed "s/ .\+//g"`
	dir=`echo ${file_n} | sed "s/....$//g"`
	file=${data_dir}/${dir}/cvt-signal/${file_n}.wav
	echo "${file_n} ${file}" >> ${WAV_SCP_FILE}
done < ${TRN_FILE} 
echo "Complete generating wav.scp file."
