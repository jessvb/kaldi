export LC_ALL=C

export KALDI_ROOT="../../.."
export K_TOOLS_DIR="${KALDI_ROOT}/tools"
export PROJ_ROOT=".."
export DATA_ROOT="/export/LDC97S63/cmu_kids"
export TRN_FILE="${DATA_ROOT}/tables/transcrp.tbl"

export DATA_DIR="${PROJ_ROOT}/data"
export TRAIN_DIR="${DATA_DIR}/train"
export TEXT_FILE="${TRAIN_DIR}/text"
export WAV_SCP_FILE="${TRAIN_DIR}/wav.scp"
export SEGMENT_FILE="${TRAIN_DIR}/segment"
export R2F_AND_CHANNEL_FILE="${TRAIN_DIR}/reco2file_and_channel"
export UTT2SPK_FILE="${TRAIN_DIR}/utt2spk"
