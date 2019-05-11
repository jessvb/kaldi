
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

. ${LOCAL_DIR}/g300_trn_gen.sh >> ${DATA_LOCAL_DIR}/train_childspeech.txt

. ${LOCAL_DIR}/g300_list_gen.sh >> ${DATA_LOCAL_DIR}/waves_all.list

cp ${DATA_LOCAL_DIR}/waves_all.list ${DATA_LOCAL_DIR}/waves.train

. ${LOCAL_DIR}/g300_wav_scp_gen.sh >> ${DATA_LOCAL_DIR}/train_childspeech_wav.scp

. ${LOCAL_DIR}/arpa_gen.sh ${DATA_LOCAL_DIR}/train_childspeech.txt ${INPUT_DIR}/task.arpabo

let subset=1
while read line
do 
	if [ ${subset} -gt ${TEST_SUBSET} ]; then
		break;
	else
		let subset=${subset}+1
	fi
	echo "${line}" >> ${DATA_LOCAL_DIR}/test_childspeech.txt
done < ${DATA_LOCAL_DIR}/train_childspeech.txt

let subset=1
while read line
do 
	if [ ${subset} -gt ${TEST_SUBSET} ]; then
		break;
	else
		let subset=${subset}+1
	fi
	echo "${line}" >> ${DATA_LOCAL_DIR}/waves.test
done < ${DATA_LOCAL_DIR}/waves.train

let subset=1
while read line
do 
	if [ ${subset} -gt ${TEST_SUBSET} ]; then
		break;
	else
		let subset=${subset}+1
	fi
	echo "${line}" >> ${DATA_LOCAL_DIR}/test_childspeech_wav.scp
done < ${DATA_LOCAL_DIR}/train_childspeech_wav.scp

echo "Complete data preparing."
