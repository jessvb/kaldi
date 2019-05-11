#!/bin/bash

# This script generates the transcription file needed by 
# kaldi, it reads through the label files of each audio file,
# and compose the transcription according to the word part
# of the file. 
#
# cmu_kids corpus does provide a transcript, but there are
# some mistakes, so I decided to build up a new transcript
# from scratch.

trn_dir="${DATA_ROOT}/kids"

if [ -f ${TRN_FILE} ]; then
	rm ${TRN_FILE}
fi

echo "Start generating text file"
let subset=1
for sub_dir in ${trn_dir}/*
do
	for label_file in ${sub_dir}/label/*
	do
		if [ ${subset} -gt ${CORPUS_SUBSET} ]; then
			break;
		else
			let subset=${subset}+1
		fi
		file=`basename ${label_file} .lbl`
		trn=`cat ${label_file} |\
			grep -w "${file}:word>" |\
			sed "s/\([^ ]\+\) \+\([^ ]\+\) \+\([^ ]\+\) \+\(.\+\)/\2/g" |\
			tr "\n" " "`
		#echo ${file} ${trn} >> ${PROJ_ROOT}/temp_trn.txt
		if [ ! -z "${trn}" ]; then
			echo ${file} ${trn} >> ${TRN_FILE}
		fi
	done
done
echo "Complete generating text file"
