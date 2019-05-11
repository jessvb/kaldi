#!/bin/bash

# This script prepares all the data needed by kaldi

if [ -d ${TMP_DIR} ]; then
	rm -rf ${TMP_DIR}
fi
mkdir -p ${TMP_DIR}	

if [ -d ${DATA_LOCAL_DIR} ]; then
	rm -rf ${DATA_LOCAL_DIR}
fi
mkdir -p ${DATA_LOCAL_DIR}	

echo "Start data preparing."

if [ -f ${DATA_LOCAL_DIR}/oovs.txt ]; then
	rm -rf ${DATA_LOCAL_DIR}/oovs.txt
fi
echo "<UNK>" >> ${DATA_LOCAL_DIR}/oovs.txt
echo "95441" >> ${DATA_LOCAL_DIR}/oov.int
#echo "/" >> ${DATA_LOCAL_DIR}/oovs.txt

. ${LOCAL_DIR}/trn_gen.sh

. ${LOCAL_DIR}/list_gen.sh

. ${LOCAL_DIR}/waves_gen.sh

. ${LOCAL_DIR}/wav_scp_gen.sh

. ${LOCAL_DIR}/arpa_gen.sh ${TRN_FILE} ${INPUT_DIR}/task.arpabo

cp ${TRN_FILE} ${TEXT_FILE}

let subset=1
while read line
do 
	if [ ${subset} -gt ${TEST_SUBSET} ]; then
		break;
	else
		let subset=${subset}+1
	fi
	echo "${line}" >> ${DATA_LOCAL_DIR}/test_childspeech.txt
done < ${TEXT_FILE}

cp ${TEXT_FILE} ${DATA_LOCAL_DIR}/train_childspeech.txt

let subset=1
while read line
do 
	if [ ${subset} -gt ${TEST_SUBSET} ]; then
		break;
	else
		let subset=${subset}+1
	fi
	echo "${line}" >> ${DATA_LOCAL_DIR}/waves.test
done < ${WAVES_FILE}

cp ${WAVES_FILE} ${DATA_LOCAL_DIR}/waves.train

let subset=1
while read line
do 
	if [ ${subset} -gt ${TEST_SUBSET} ]; then
		break;
	else
		let subset=${subset}+1
	fi
	echo "${line}" >> ${DATA_LOCAL_DIR}/test_childspeech_wav.scp
done < ${WAV_SCP_FILE}

cp ${WAV_SCP_FILE} ${DATA_LOCAL_DIR}/train_childspeech_wav.scp

echo "Complete data preparing."
