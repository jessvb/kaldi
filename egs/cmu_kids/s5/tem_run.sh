#!/bin/bash

. ./path.sh

# If you have cluster of machines running GridEngine you may want to
# change the train and decode commands in the file below
#. ./cmd.sh

# The number of parallel jobs to be started for some parts of the recipe
# Make sure you have enough resources(CPUs and RAM) to accomodate this number of jobs

function checkStatus() {
	if [ $? -ne 0 ]; then 
		echo "Run $1 fail."
		exit 1
	else 
		echo "$1 succeed."
	fi
}

njobs=2

train_base_name=train_childspeech
test_base_name=test_childspeech
curdir=`pwd`
train_cmd="scripts/rms5_run.pl"

#	if [ ! -d ${TMP_DIR} ]; then
#		mkdir -p ${TMP_DIR}
#	fi
#
#	${LOCAL_DIR}/childspeech_data_prep.sh
#
#	${LOCAL_DIR}/childspeech_dict_prep.sh
#
#	${LOCAL_DIR}/childspeech_format_data.sh
#
#
#	# Feature extraction
#    mfccdir=${MFCC_DIR}
#	for x in ${train_base_name} ${test_base_name}; do 
#	 steps/make_mfcc.sh data/$x exp/make_mfcc/$x $mfccdir 1
#	done

	# train monophone system.
	steps/rms5_train_mono.sh --nj 4 --cmd "$train_cmd" \
		data/${train_base_name} data/lang exp/mono  || exit 1;

	# Get alignments from monophone system.

	# train tri1 [first triphone pass]

	# align tri1

	# train tri2a [delta+delta-deltas]

#	# Graph compilation  

#	# Decoding
#	decode_cmd="scripts/run.pl"
