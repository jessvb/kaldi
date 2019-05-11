#!/bin/bash

# This script generates the list of all the
# files to be trained.

if [ -f ${WAV_LIST_FILE} ]; then
	rm ${WAV_LIST_FILE}
fi


echo "Start generating list file"
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
	echo "${file_n}" >> ${WAV_LIST_FILE}
done < ${TRN_FILE}
echo "Complete generating list file"
