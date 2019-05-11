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

function data_prep(){
#	if [ $# -ne 1 ]; then
#		echo "usage: $0 [cmu|gina]"
#		exit 1
#	fi
	#if [ $1 == "cmu" ]; then
		${LOCAL_DIR}/childspeech_data_prep.sh
		${LOCAL_DIR}/childspeech_dict_prep.sh
		${LOCAL_DIR}/childspeech_format_data.sh
#	elif [ $1 == "gina" ]; then 
#		${LOCAL_DIR}/g300_data_prep.sh
#		${LOCAL_DIR}/g300_dict_prep.sh
#		${LOCAL_DIR}/g300_format_data.sh
#	else 
#		echo "usage: $0 [cmu|gina]"
#		exit 1
#	fi
}

function data_training() {
	# train monophone system.
	steps/rm_train_mono.sh data/${train_base_name} data/lang exp/mono  || exit 1;

	# Get alignments from monophone system.
	steps/rm_align_deltas.sh data/${train_base_name} data/lang exp/mono exp/mono_ali || exit 1;

	# train tri1 [first triphone pass]
	steps/rm_train_deltas.sh data/${train_base_name} data/lang exp/mono_ali exp/tri1 || exit 1;

	# align tri1
	steps/rm_align_deltas.sh --graphs "ark,s,cs:gunzip -c exp/tri1/graphs.fsts.gz|" \
		data/${train_base_name} data/lang exp/tri1 exp/tri1_ali || exit 1;

	# train tri2a [delta+delta-deltas]
	steps/rm_train_deltas.sh data/${train_base_name} data/lang exp/tri1_ali exp/tri2a || exit 1;
}

function mkgraph() {
	if [ $# -ne 1 ]; then
		echo "usage: $0 lm_dir"
		exit 1
	fi
	#Graph compilation  
	scripts/rm_mkgraph.sh $1 exp/tri2a exp/tri2a/graph || exit 1
}

function decode() {
	decode_cmd="scripts/run.pl"
	local/decode.sh steps/rm_decode_deltas.sh exp/tri2a/decode_${test_base_name} || exit 1
}

njobs=2

train_base_name=train_childspeech
test_base_name=test_childspeech
lm_dir=data/lang_test_tg
curdir=`pwd`
train_cmd="scripts/run.pl"

	if [ ! -d ${TMP_DIR} ]; then
		mkdir -p ${TMP_DIR}
	fi
	
	if [ ${EXPERIMENT} == 0 ]; then
		# Data preparation
		data_prep cmu
		# Feature extraction
		mfccdir=${MFCC_DIR}
		for x in ${train_base_name} ${test_base_name}; do 
			steps/make_mfcc.sh data/$x exp/make_mfcc/$x $mfccdir/experiment0 1
		done
		data_training
		mkgraph ${lm_dir}
		decode
	elif [ ${EXPERIMENT} == 1 ]; then
		echo "to be completed"
		data_prep gina
		mv data/lang_test_tg g300_lang
		mv data/test_childspeech g300_test
		# Data preparation
		data_prep cmu
		# Feature extraction
		mfccdir=${MFCC_DIR}
		for x in ${train_base_name} g300_test; do 
			steps/make_mfcc.sh data/$x exp/make_mfcc/$x $mfccdir/experiment1 1
		done
		data_training
		mkgraph g300_lang
		rm -rf g300_lang
		mv data/test_childspeech/feats.scp g300_test
		rm -rf data/test_childspeech
		mv g300_test data/test_childspeech
		decode
	elif [ ${EXPERIMENT} == 2 ]; then
		# Data preparation
		data_prep gina
		# Feature extraction
		mfccdir=${MFCC_DIR}
		for x in ${train_base_name} ${test_base_name}; do 
			steps/make_mfcc.sh data/$x exp/make_mfcc/$x $mfccdir/experiment2 1
		done
		data_training
		mkgraph ${lm_dir}
		decode
	elif [ ${EXPERIMENT} == 3 ]; then
		echo "to be completed"
		# Data preparation
		data_prep
		# Feature extraction
		mfccdir=${MFCC_DIR}
		for x in ${train_base_name} ${test_base_name}; do 
			steps/make_mfcc.sh data/$x exp/make_mfcc/$x $mfccdir/experiment3 1
		done
		data_training
		mkgraph
		decode
	elif [ ${EXPERIMENT} == 4 ]; then
		echo "to be completed"
		# Data preparation
		data_prep
		# Feature extraction
		mfccdir=${MFCC_DIR}
		for x in ${train_base_name} ${test_base_name}; do 
			steps/make_mfcc.sh data/$x exp/make_mfcc/$x $mfccdir/experiment4 1
		done
		data_training
		mkgraph
		decode
	elif [ ${EXPERIMENT} == "5a" ]; then
		echo "to be completed"
		# Data preparation
		data_prep
		# Feature extraction
		mfccdir=${MFCC_DIR}
		for x in ${train_base_name} ${test_base_name}; do 
			steps/make_mfcc.sh data/$x exp/make_mfcc/$x $mfccdir/experiment5a 1
		done
		data_training
		mkgraph
		decode
	elif [ ${EXPERIMENT} == 5 ]; then
		echo "to be completed"
		# Data preparation
		data_prep
		# Feature extraction
		mfccdir=${MFCC_DIR}
		for x in ${train_base_name} ${test_base_name}; do 
			steps/make_mfcc.sh data/$x exp/make_mfcc/$x $mfccdir/experiment5 1
		done
		data_training
		mkgraph
		decode
	else
		echo "${EXPERIMENT}: no such experiment."
		exit 1
	fi
