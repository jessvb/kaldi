#export KALDI_ROOT=`pwd`/../../..
export KALDI_ROOT="/workspace/zhorai-workspace/kaldi"

## FOR arpa2fst and kaldi stuff:
[ -f $KALDI_ROOT/tools/env.sh ] && . $KALDI_ROOT/tools/env.sh
export PATH=$PWD/utils/:$KALDI_ROOT/tools/openfst/bin:$KALDI_ROOT/tools/irstlm/bin/:$PWD:$PATH
[ ! -f $KALDI_ROOT/tools/config/common_path.sh ] && echo >&2 "The standard file $KALDI_ROOT/tools/config/common_path.sh is not present -> Exit!" && exit 1
. $KALDI_ROOT/tools/config/common_path.sh


export PATH=$PWD/scripts:$PWD/utils/:$KALDI_ROOT/src/bin:$KALDI_ROOT/tools/openfst/bin:$KALDI_ROOT/src/fstbin/:$KALDI_ROOT/src/gmmbin/:$KALDI_ROOT/src/featbin/:$KALDI_ROOT/src/lm/:$KALDI_ROOT/src/sgmmbin/:$KALDI_ROOT/src/sgmm2bin/:$KALDI_ROOT/src/fgmmbin/:$KALDI_ROOT/src/latbin/:$PWD:$PATH

export LC_ALL=C

# Paths that relate to project and corpus
export K_TOOLS_DIR="${KALDI_ROOT}/tools"
#export PROJ_ROOT="${KALDI_ROOT}/egs/childspeech-final"
export PROJ_ROOT="${KALDI_ROOT}/egs/cmu_kids/s5"
#export DATA_ROOT="/export/LDC97S63-test/cmu_kids"
export DATA_ROOT="/workspace/zhorai-workspace/datasets/cmu_kids" # unclear if this needs cmu_kids/kids
#TODO:#export GINA300_DATA_ROOT="/home/guhehehe/hg/gina300"
#export TRN_FILE="${PROJ_ROOT}/input/transcrp.tbl"
export TRN_FILE="${PROJ_ROOT}/input/plain_trans.txt"

# Directories in project root 
export LOCAL_DIR="${PROJ_ROOT}/local"
# mfcc directory could be super large, so choose a large disk space
# for this bad boy.
export MFCC_DIR="${PROJ_ROOT}/../mfcc"
export MFCC_LOG_DIR="${PROJ_ROOT}/exp/make_mfcc/train"
export DATA_DIR="${PROJ_ROOT}/data"
export INPUT_DIR="${PROJ_ROOT}/input"

# data/train
export TMP_DIR="${DATA_DIR}/temp"
export TRAIN_DIR="${DATA_DIR}/train"
export DATA_LOCAL_DIR="${DATA_DIR}/local"
export TEXT_FILE="${TMP_DIR}/childspeech.txt"
export WAVES_FILE="${TMP_DIR}/waves"
export WAV_SCP_FILE="${TMP_DIR}/childspeech_wav.scp"
export SEGMENT_FILE="${TMP_DIR}/childspeech_segments.txt"
export R2F_AND_CHANNEL_FILE="${TMP_DIR}/reco2file_and_channel"
export UTT2SPK_FILE="${TMP_DIR}/utt2spk"
export WAV_LIST_FILE="${DATA_LOCAL_DIR}/waves_all.list"

# data/lang
#export LANG_DIR="${DATA_DIR}/lang"
export LANG_DIR="${DATA_DIR}/lang_test_bg"

# data/local
export LOC_DIR="${DATA_DIR}/local"

# size of the subset of the corpus, and the test subset
# the CORPUS_SUBSET is the subset upon which the system is trained
# the TEST_SUBSET is the subset upon which the recognizing is tested
export CORPUS_SUBSET=9 #1000
export TEST_SUBSET=3 #200

# different experiments
# currently available experiments are:
# 0 - trained on CMU / CMU -> test with CMU LM against CMU
# 1 - trained on CMU / CMU -> test with CMU LM against G300 
# 2 - trained on G300 / G3 -> test with G3 LM against G300 
# experiments that will be implemented in the future:
# 3 - (currently working on) train on CMU / CMU -> test with G3 LM against G300 = (WER against G3?)
# 4 - train on CMU / CMU + Gina60 / G3 -> test with G3 LM against G300  = (WER against G3?)
# 5a - transcribe 60 
# 5 - train on CMU / CMU + Gina60 / Gina60 -> test with G60 LM against G60 = (WER against G60)
export EXPERIMENT=0
