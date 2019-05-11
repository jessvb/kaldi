#!/bin/bash

# Note: this TIDIGITS setup has not been tuned at all and has some obvious
# deficiencies; this has been created as a starting point for a tutorial.
# We're just using the "adults" data here, not the data from children.

. ./cmd.sh ## You'll want to change cmd.sh to something that will work on your system.
           ## This relates to the queue.

# This is a shell script, but it's recommended that you run the commands one by
# one by copying and pasting into the shell.

# Acoustic model parameters (from timit run dnn)
numLeavesTri1=2500
numGaussTri1=15000
numLeavesMLLT=2500
numGaussMLLT=15000
numLeavesSAT=2500
numGaussSAT=15000
numGaussUBM=400
numLeavesSGMM=7000
numGaussSGMM=9000

feats_nj=10
train_nj=30
decode_nj=5


#tidigits=/export/corpora5/LDC/LDC93S10
#tidigits=/mnt/matylda2/data/TIDIGITS
#tidigits=/workspace/zhorai-workspace/datasets/tidigits-orig # @BUT
tidigits=/workspace/zhorai-workspace/datasets/tidigits_tr-adj10_te-ac # @BUT


# The following command prepares the data/{train,dev,test} directories.
local/tidigits_data_prep.sh $tidigits || exit 1;
local/tidigits_prepare_lang.sh  || exit 1; # This makes the lang in the data/lang_test_bg folder
#utils/validate_lang.pl data/lang/ # Note; this actually does report errors, ## ORIGINALLY THIS WAS JUST DATA/LANG
utils/validate_lang.pl data/lang_test_bg/ # Note; this actually does report errors, ## ORIGINALLY THIS WAS JUST DATA/LANG
   # and exits with status 1, but we've checked them and seen that they
   # don't matter (this setup doesn't have any disambiguation symbols,
   # and the script doesn't like that).


echo ============================================================================
echo "         MFCC Feature Extration & CMVN for Training and Test set          "
echo ============================================================================

# Now make MFCC features.
# mfccdir should be some place with a largish disk where you
# want to store MFCC features.
mfccdir=mfcc
for x in test train; do
 steps/make_mfcc.sh --cmd "$train_cmd" --nj 20 \
   data/$x exp/make_mfcc/$x $mfccdir || exit 1;
 steps/compute_cmvn_stats.sh data/$x exp/make_mfcc/$x $mfccdir || exit 1;
done

#utils/subset_data_dir.sh data/train 1000 data/train_1k TODO: is it okay if I don't subset this??

echo ============================================================================
echo "                MonoPhone and tri1 Training & Decoding                    "
echo ============================================================================

# try --boost-silence 1.25 to some of the scripts below (also 1.5, if that helps...
# effect may not be clear till we test triphone system.  See
# wsj setup for examples (../../wsj/s5/run.sh)

steps/train_mono.sh  --nj "$train_nj" --cmd "$train_cmd" \
  data/train data/lang_test_bg exp/mono ## TODO: switched from data_1k to just data AND from data/lang to data/lang_test_bg

 utils/mkgraph.sh data/lang_test_bg exp/mono exp/mono/graph && \
 steps/decode.sh --nj "$decode_nj" --cmd "$decode_cmd" \
      exp/mono/graph data/test exp/mono/decode_test


echo ==================== tri1 =====================

steps/align_si.sh --nj "$train_nj" --cmd "$train_cmd" \
   data/train data/lang_test_bg exp/mono exp/mono_ali

steps/train_deltas.sh --cmd "$train_cmd" \
    $numLeavesTri1 $numGaussTri1 data/train data/lang_test_bg exp/mono_ali exp/tri1


 utils/mkgraph.sh data/lang_test_bg exp/tri1 exp/tri1/graph
 
steps/decode.sh --nj "$decode_nj" --cmd "$decode_cmd" \
      exp/tri1/graph data/test exp/tri1/decode_test

# Example of looking at the output.
# utils/int2sym.pl -f 2- data/lang/words.txt  exp/tri1/decode/scoring/19.tra | sed "s/ $//" | sort | diff - data/test/text


# Getting results [see RESULTS file]
# for x in exp/*/decode*; do [ -d $x ] && grep SER $x/wer_* | utils/best_wer.sh; done

#exp/mono/decode/wer_17:%SER 3.67 [ 319 / 8700 ]
#exp/tri1/decode/wer_19:%SER 2.64 [ 230 / 8700 ]

echo ============================================================================
echo "                 tri2 : LDA + MLLT Training & Decoding                    "
echo ============================================================================

steps/align_si.sh --nj 4 --cmd "$train_cmd" \
  data/train data/lang_test_bg exp/tri1 exp/tri1_ali

steps/train_lda_mllt.sh --cmd "$train_cmd" \
 --splice-opts "--left-context=3 --right-context=3" \
 $numLeavesMLLT $numGaussMLLT data/train data/lang_test_bg exp/tri1_ali exp/tri2

utils/mkgraph.sh data/lang_test_bg exp/tri2 exp/tri2/graph

## TODO: commenting out dev:
#steps/decode.sh --nj "$decode_nj" --cmd "$decode_cmd" \
# exp/tri2/graph data/dev exp/tri2/decode_dev

steps/decode.sh --nj "$decode_nj" --cmd "$decode_cmd" \
 exp/tri2/graph data/test exp/tri2/decode_test

echo ============================================================================
echo "              tri3 : LDA + MLLT + SAT Training & Decoding                 "
echo ============================================================================

# Align tri2 system with train data.
steps/align_si.sh --nj "$train_nj" --cmd "$train_cmd" \
 --use-graphs true data/train data/lang_test_bg exp/tri2 exp/tri2_ali

# From tri2 system, train tri3 which is LDA + MLLT + SAT.
steps/train_sat.sh --cmd "$train_cmd" \
  $numLeavesSAT $numGaussSAT data/train data/lang_test_bg exp/tri2 exp/tri3
 ## TODO: changed this to tri2/ b/c error: $numLeavesSAT $numGaussSAT data/train data/lang_test_bg exp/tri2_ali exp/tri3

utils/mkgraph.sh data/lang_test_bg exp/tri3 exp/tri3/graph

## TODO: commenting out dev: 
#steps/decode_fmllr.sh --nj "$decode_nj" --cmd "$decode_cmd" \
# exp/tri3/graph data/dev exp/tri3/decode_dev

steps/decode_fmllr.sh --nj "$decode_nj" --cmd "$decode_cmd" \
 exp/tri3/graph data/test exp/tri3/decode_test

echo ============================================================================
echo "                        SGMM2 Training & Decoding                         "
echo ============================================================================

steps/align_fmllr.sh --nj "$train_nj" --cmd "$train_cmd" \
 data/train data/lang_test_bg exp/tri3 exp/tri3_ali


################ TODO: NOTICE THIS!!! NOTHING RUNS BENEATH THIS!!! ################
echo "DONE RUN.SH. From this point you can run Karel's DNN : local/nnet/run_dnn.sh"
exit 0 # From this point you can run Karel's DNN : local/nnet/run_dnn.sh

steps/train_ubm.sh --cmd "$train_cmd" \
 $numGaussUBM data/train data/lang_test_bg exp/tri3_ali exp/ubm4

steps/train_sgmm2.sh --cmd "$train_cmd" $numLeavesSGMM $numGaussSGMM \
 data/train data/lang_test_bg exp/tri3_ali exp/ubm4/final.ubm exp/sgmm2_4

utils/mkgraph.sh data/lang_test_bg exp/sgmm2_4 exp/sgmm2_4/graph

## TODO: commenting out dev: 
#steps/decode_sgmm2.sh --nj "$decode_nj" --cmd "$decode_cmd"\
# --transform-dir exp/tri3/decode_dev exp/sgmm2_4/graph data/dev \
# exp/sgmm2_4/decode_dev

steps/decode_sgmm2.sh --nj "$decode_nj" --cmd "$decode_cmd"\
 --transform-dir exp/tri3/decode_test exp/sgmm2_4/graph data/test \
 exp/sgmm2_4/decode_test

echo ============================================================================
echo "                    MMI + SGMM2 Training & Decoding                       "
echo ============================================================================

steps/align_sgmm2.sh --nj "$train_nj" --cmd "$train_cmd" \
 --transform-dir exp/tri3_ali --use-graphs true --use-gselect true \
 data/train data/lang_test_bg exp/sgmm2_4 exp/sgmm2_4_ali

steps/make_denlats_sgmm2.sh --nj "$train_nj" --sub-split "$train_nj" \
 --acwt 0.2 --lattice-beam 10.0 --beam 18.0 \
 --cmd "$decode_cmd" --transform-dir exp/tri3_ali \
 data/train data/lang_test_bg exp/sgmm2_4_ali exp/sgmm2_4_denlats

steps/train_mmi_sgmm2.sh --acwt 0.2 --cmd "$decode_cmd" \
 --transform-dir exp/tri3_ali --boost 0.1 --drop-frames true \
 data/train data/lang_test_bg exp/sgmm2_4_ali exp/sgmm2_4_denlats exp/sgmm2_4_mmi_b0.1

for iter in 1 2 3 4; do
## TODO: commenting out dev: 
#  steps/decode_sgmm2_rescore.sh --cmd "$decode_cmd" --iter $iter \
#   --transform-dir exp/tri3/decode_dev data/lang_test_bg data/dev \
#   exp/sgmm2_4/decode_dev exp/sgmm2_4_mmi_b0.1/decode_dev_it$iter

  steps/decode_sgmm2_rescore.sh --cmd "$decode_cmd" --iter $iter \
   --transform-dir exp/tri3/decode_test data/lang_test_bg data/test \
   exp/sgmm2_4/decode_test exp/sgmm2_4_mmi_b0.1/decode_test_it$iter
done

echo ============================================================================
echo "                    DNN Hybrid Training & Decoding                        "
echo ============================================================================

# DNN hybrid system training parameters
dnn_mem_reqs="--mem 1G"
dnn_extra_opts="--num_epochs 20 --num-epochs-extra 10 --add-layers-period 1 --shrink-interval 3"

steps/nnet2/train_tanh.sh --mix-up 5000 --initial-learning-rate 0.015 \
  --final-learning-rate 0.002 --num-hidden-layers 2  \
  --num-jobs-nnet "$train_nj" --cmd "$train_cmd" "${dnn_train_extra_opts[@]}" \
  data/train data/lang_test_bg exp/tri3_ali exp/tri4_nnet

## TODO: commenting out dev: 
#[ ! -d exp/tri4_nnet/decode_dev ] && mkdir -p exp/tri4_nnet/decode_dev
#decode_extra_opts=(--num-threads 6)
#steps/nnet2/decode.sh --cmd "$decode_cmd" --nj "$decode_nj" "${decode_extra_opts[@]}" \
#  --transform-dir exp/tri3/decode_dev exp/tri3/graph data/dev \
#  exp/tri4_nnet/decode_dev | tee exp/tri4_nnet/decode_dev/decode.log

[ ! -d exp/tri4_nnet/decode_test ] && mkdir -p exp/tri4_nnet/decode_test
steps/nnet2/decode.sh --cmd "$decode_cmd" --nj "$decode_nj" "${decode_extra_opts[@]}" \
  --transform-dir exp/tri3/decode_test exp/tri3/graph data/test \
  exp/tri4_nnet/decode_test | tee exp/tri4_nnet/decode_test/decode.log

echo ============================================================================
echo "                    System Combination (DNN+SGMM)                         "
echo ============================================================================

for iter in 1 2 3 4; do
## TODO: commenting out dev: 
#  local/score_combine.sh --cmd "$decode_cmd" \
#   data/dev data/lang_test_bg exp/tri4_nnet/decode_dev \
#   exp/sgmm2_4_mmi_b0.1/decode_dev_it$iter exp/combine_2/decode_dev_it$iter

  local/score_combine.sh --cmd "$decode_cmd" \
   data/test data/lang_test_bg exp/tri4_nnet/decode_test \
   exp/sgmm2_4_mmi_b0.1/decode_test_it$iter exp/combine_2/decode_test_it$iter
done

echo ============================================================================
echo "               DNN Hybrid Training & Decoding (Karel's recipe)            "
echo ============================================================================

local/nnet/run_dnn.sh
#local/nnet/run_autoencoder.sh : an example, not used to build any system,

echo ============================================================================
echo "                    Getting Results [see RESULTS file]                    "
echo ============================================================================

## TODO: commenting out dev: 
#bash RESULTS dev
bash RESULTS test

echo ============================================================================
echo "Finished successfully on" `date`
echo ============================================================================

exit 0


echo DONE MFCC AND MONO AND TRI
