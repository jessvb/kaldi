#!/bin/bash

. ./path.sh

# If you have cluster of machines running GridEngine you may want to
# change the train and decode commands in the file below
#. ./cmd.sh

# The number of parallel jobs to be started for some parts of the recipe
# Make sure you have enough resources(CPUs and RAM) to accomodate this number of jobs
njobs=2

train_base_name=train_childspeech
test_base_name=test_childspeech
curdir=`pwd`

if [ ! -d ${TMP_DIR} ]; then
	mkdir -p ${TMP_DIR}
fi

	${LOCAL_DIR}/childspeech_data_prep.sh

	${LOCAL_DIR}/childspeech_dict_prep.sh

	${LOCAL_DIR}/childspeech_format_data.sh


	# Feature extraction
	mfccdir=${MFCC_DIR}
	for x in ${train_base_name} ${test_base_name}; do 
	 steps/make_mfcc.sh data/$x exp/make_mfcc/$x $mfccdir 1
	done



	# Mono training
	train_cmd="scripts/run.pl"
	steps/train_mono.sh --num-jobs 1 --cmd "$train_cmd" \
	  --start-gauss 30 --end-gauss 400 \
	  data/${train_base_name} data/lang exp/mono0a 
	  
	# Graph compilation  
	scripts/mkgraph.sh --mono data/lang_test_tg exp/mono0a exp/mono0a/graph_tgpr

	# Decoding
	decode_cmd="scripts/run.pl"
	scripts/decode.sh --num-jobs 1 --cmd "$decode_cmd" --opts "--beam 10.0 --lattice-beam 5.0" \
	   steps/decode_deltas.sh exp/mono0a/graph_tgpr data/${test_base_name} exp/mono0a/decode_${test_base_name}
