steps/nnet/make_fmllr_feats.sh --nj 10 --cmd run.pl --mem 2G --transform-dir exp/tri3/decode_test data-fmllr-tri3/test data/test exp/tri3 data-fmllr-tri3/test/log data-fmllr-tri3/test/data
steps/nnet/make_fmllr_feats.sh: feature type is lda_fmllr
utils/copy_data_dir.sh: copied data from data/test to data-fmllr-tri3/test
utils/validate_data_dir.sh: Successfully validated data-directory data-fmllr-tri3/test
steps/nnet/make_fmllr_feats.sh: Done!, type lda_fmllr, data/test --> data-fmllr-tri3/test, using : raw-trans None, gmm exp/tri3, trans exp/tri3/decode_test
steps/nnet/make_fmllr_feats.sh --nj 10 --cmd run.pl --mem 2G --transform-dir exp/tri3_ali data-fmllr-tri3/train data/train exp/tri3 data-fmllr-tri3/train/log data-fmllr-tri3/train/data
steps/nnet/make_fmllr_feats.sh: feature type is lda_fmllr
utils/copy_data_dir.sh: copied data from data/train to data-fmllr-tri3/train
utils/validate_data_dir.sh: Successfully validated data-directory data-fmllr-tri3/train
steps/nnet/make_fmllr_feats.sh: Done!, type lda_fmllr, data/train --> data-fmllr-tri3/train, using : raw-trans None, gmm exp/tri3, trans exp/tri3_ali
Speakers, src=108, trn=98, cv=10 /tmp/$(whoami)_mN65z/speakers_cv
utils/data/subset_data_dir.sh: reducing #utt from 8314 to 7544
utils/data/subset_data_dir.sh: reducing #utt from 8314 to 770
# steps/nnet/pretrain_dbn.sh --hid-dim 1024 --rbm-iter 20 data-fmllr-tri3/train exp/dnn4_pretrain-dbn 
# Started at Wed May  8 13:44:36 UTC 2019
#
steps/nnet/pretrain_dbn.sh --hid-dim 1024 --rbm-iter 20 data-fmllr-tri3/train exp/dnn4_pretrain-dbn
# INFO
steps/nnet/pretrain_dbn.sh : Pre-training Deep Belief Network as a stack of RBMs
	 dir       : exp/dnn4_pretrain-dbn 
	 Train-set : data-fmllr-tri3/train '8314'

LOG ([5.5.286~1-b96ca]:main():cuda-gpu-available.cc:60) 

### IS CUDA GPU AVAILABLE? '2fbdb5a7a42f' ###
WARNING ([5.5.286~1-b96ca]:SelectGpuId():cu-device.cc:221) Not in compute-exclusive mode.  Suggestion: use 'nvidia-smi -c 3' to set compute exclusive mode
LOG ([5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:349) Selecting from 1 GPUs
LOG ([5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:364) cudaSetDevice(0): Tesla P100-PCIE-16GB	free:16017M, used:263M, total:16280M, free/total:0.983846
LOG ([5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:411) Trying to select device: 0 (automatically), mem_ratio: 0.983846
LOG ([5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:430) Success selecting device 0 free mem ratio: 0.983846
LOG ([5.5.286~1-b96ca]:FinalizeActiveGpu():cu-device.cc:284) The active GPU is [0]: Tesla P100-PCIE-16GB	free:15953M, used:327M, total:16280M, free/total:0.979915 version 6.0
### HURRAY, WE GOT A CUDA GPU FOR COMPUTATION!!! ##

### Testing CUDA setup with a small computation (setup = cuda-toolkit + gpu-driver + kaldi):
### Test OK!

# PREPARING FEATURES
copy-feats --compress=true scp:data-fmllr-tri3/train/feats.scp ark,scp:/tmp/kaldi.0YFS/train.ark,exp/dnn4_pretrain-dbn/train_sorted.scp 
LOG (copy-feats[5.5.286~1-b96ca]:main():copy-feats.cc:143) Copied 8314 feature matrices.
# 'apply-cmvn' not used,
feat-to-dim 'ark:copy-feats scp:exp/dnn4_pretrain-dbn/train.scp ark:- |' - 
copy-feats scp:exp/dnn4_pretrain-dbn/train.scp ark:- 
WARNING (feat-to-dim[5.5.286~1-b96ca]:Close():kaldi-io.cc:515) Pipe copy-feats scp:exp/dnn4_pretrain-dbn/train.scp ark:- | had nonzero return status 36096
# feature dim : 40 (input of 'feature_transform')
+ default 'feature_transform_proto' with splice +/-5 frames
nnet-initialize --binary=false exp/dnn4_pretrain-dbn/splice5.proto exp/dnn4_pretrain-dbn/tr_splice5.nnet 
VLOG[1] (nnet-initialize[5.5.286~1-b96ca]:Init():nnet-nnet.cc:314) <Splice> <InputDim> 40 <OutputDim> 440 <BuildVector> -5:5 </BuildVector>
LOG (nnet-initialize[5.5.286~1-b96ca]:main():nnet-initialize.cc:63) Written initialized model to exp/dnn4_pretrain-dbn/tr_splice5.nnet
# compute normalization stats from 10k sentences
compute-cmvn-stats ark:- exp/dnn4_pretrain-dbn/cmvn-g.stats 
nnet-forward --print-args=true --use-gpu=yes exp/dnn4_pretrain-dbn/tr_splice5.nnet 'ark:copy-feats scp:exp/dnn4_pretrain-dbn/train.scp.10k ark:- |' ark:- 
WARNING (nnet-forward[5.5.286~1-b96ca]:SelectGpuId():cu-device.cc:221) Not in compute-exclusive mode.  Suggestion: use 'nvidia-smi -c 3' to set compute exclusive mode
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:349) Selecting from 1 GPUs
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:364) cudaSetDevice(0): Tesla P100-PCIE-16GB	free:16017M, used:263M, total:16280M, free/total:0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:411) Trying to select device: 0 (automatically), mem_ratio: 0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:430) Success selecting device 0 free mem ratio: 0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:FinalizeActiveGpu():cu-device.cc:284) The active GPU is [0]: Tesla P100-PCIE-16GB	free:15953M, used:327M, total:16280M, free/total:0.979915 version 6.0
copy-feats scp:exp/dnn4_pretrain-dbn/train.scp.10k ark:- 
LOG (copy-feats[5.5.286~1-b96ca]:main():copy-feats.cc:143) Copied 8314 feature matrices.
LOG (nnet-forward[5.5.286~1-b96ca]:main():nnet-forward.cc:192) Done 8314 files in 0.117306min, (fps 223251)
LOG (compute-cmvn-stats[5.5.286~1-b96ca]:main():compute-cmvn-stats.cc:168) Wrote global CMVN stats to exp/dnn4_pretrain-dbn/cmvn-g.stats
LOG (compute-cmvn-stats[5.5.286~1-b96ca]:main():compute-cmvn-stats.cc:171) Done accumulating CMVN stats for 8314 utterances; 0 had errors.
# + normalization of NN-input at 'exp/dnn4_pretrain-dbn/tr_splice5_cmvn-g.nnet'
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:53) Reading exp/dnn4_pretrain-dbn/tr_splice5.nnet
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:65) Concatenating cmvn-to-nnet exp/dnn4_pretrain-dbn/cmvn-g.stats -|
cmvn-to-nnet exp/dnn4_pretrain-dbn/cmvn-g.stats - 
LOG (cmvn-to-nnet[5.5.286~1-b96ca]:main():cmvn-to-nnet.cc:114) Written cmvn in 'nnet1' model to: -
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:82) Written model to exp/dnn4_pretrain-dbn/tr_splice5_cmvn-g.nnet

### Showing the final 'feature_transform':
nnet-info exp/dnn4_pretrain-dbn/tr_splice5_cmvn-g.nnet 
num-components 3
input-dim 40
output-dim 440
number-of-parameters 0.00088 millions
component 1 : <Splice>, input-dim 40, output-dim 440, 
  frame_offsets [ -5 -4 -3 -2 -1 0 1 2 3 4 5 ]
component 2 : <AddShift>, input-dim 440, output-dim 440, 
  shift_data ( min -0.142944, max 0.230102, mean 0.00477159, stddev 0.0441806, skewness 2.40504, kurtosis 14.063 ) , lr-coef 0
component 3 : <Rescale>, input-dim 440, output-dim 440, 
  scale_data ( min 0.260659, max 1.03973, mean 0.771155, stddev 0.181016, skewness -0.570236, kurtosis -0.0180144 ) , lr-coef 0
LOG (nnet-info[5.5.286~1-b96ca]:main():nnet-info.cc:57) Printed info about exp/dnn4_pretrain-dbn/tr_splice5_cmvn-g.nnet
###

# PRE-TRAINING RBM LAYER 1
# initializing 'exp/dnn4_pretrain-dbn/1.rbm.init'
# pretraining 'exp/dnn4_pretrain-dbn/1.rbm' (input gauss, lrate 0.01, iters 40)
# converting RBM to exp/dnn4_pretrain-dbn/1.dbn
rbm-convert-to-nnet exp/dnn4_pretrain-dbn/1.rbm exp/dnn4_pretrain-dbn/1.dbn 
LOG (rbm-convert-to-nnet[5.5.286~1-b96ca]:main():rbm-convert-to-nnet.cc:69) Written model to exp/dnn4_pretrain-dbn/1.dbn

# PRE-TRAINING RBM LAYER 2
# computing cmvn stats 'exp/dnn4_pretrain-dbn/2.cmvn' for RBM initialization
WARNING (nnet-forward[5.5.286~1-b96ca]:SelectGpuId():cu-device.cc:221) Not in compute-exclusive mode.  Suggestion: use 'nvidia-smi -c 3' to set compute exclusive mode
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:349) Selecting from 1 GPUs
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:364) cudaSetDevice(0): Tesla P100-PCIE-16GB	free:16017M, used:263M, total:16280M, free/total:0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:411) Trying to select device: 0 (automatically), mem_ratio: 0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:430) Success selecting device 0 free mem ratio: 0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:FinalizeActiveGpu():cu-device.cc:284) The active GPU is [0]: Tesla P100-PCIE-16GB	free:15953M, used:327M, total:16280M, free/total:0.979915 version 6.0
nnet-concat exp/dnn4_pretrain-dbn/final.feature_transform exp/dnn4_pretrain-dbn/1.dbn - 
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:53) Reading exp/dnn4_pretrain-dbn/final.feature_transform
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:65) Concatenating exp/dnn4_pretrain-dbn/1.dbn
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:82) Written model to -
copy-feats scp:exp/dnn4_pretrain-dbn/train.scp.10k ark:- 
LOG (copy-feats[5.5.286~1-b96ca]:main():copy-feats.cc:143) Copied 8314 feature matrices.
LOG (nnet-forward[5.5.286~1-b96ca]:main():nnet-forward.cc:192) Done 8314 files in 0.2475min, (fps 105813)
LOG (compute-cmvn-stats[5.5.286~1-b96ca]:main():compute-cmvn-stats.cc:168) Wrote global CMVN stats to standard output
LOG (compute-cmvn-stats[5.5.286~1-b96ca]:main():compute-cmvn-stats.cc:171) Done accumulating CMVN stats for 8314 utterances; 0 had errors.
LOG (cmvn-to-nnet[5.5.286~1-b96ca]:main():cmvn-to-nnet.cc:114) Written cmvn in 'nnet1' model to: exp/dnn4_pretrain-dbn/2.cmvn
initializing 'exp/dnn4_pretrain-dbn/2.rbm.init'
pretraining 'exp/dnn4_pretrain-dbn/2.rbm' (lrate 0.4, iters 20)
# appending RBM to exp/dnn4_pretrain-dbn/2.dbn
nnet-concat exp/dnn4_pretrain-dbn/1.dbn 'rbm-convert-to-nnet exp/dnn4_pretrain-dbn/2.rbm - |' exp/dnn4_pretrain-dbn/2.dbn 
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:53) Reading exp/dnn4_pretrain-dbn/1.dbn
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:65) Concatenating rbm-convert-to-nnet exp/dnn4_pretrain-dbn/2.rbm - |
rbm-convert-to-nnet exp/dnn4_pretrain-dbn/2.rbm - 
LOG (rbm-convert-to-nnet[5.5.286~1-b96ca]:main():rbm-convert-to-nnet.cc:69) Written model to -
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:82) Written model to exp/dnn4_pretrain-dbn/2.dbn

# PRE-TRAINING RBM LAYER 3
# computing cmvn stats 'exp/dnn4_pretrain-dbn/3.cmvn' for RBM initialization
WARNING (nnet-forward[5.5.286~1-b96ca]:SelectGpuId():cu-device.cc:221) Not in compute-exclusive mode.  Suggestion: use 'nvidia-smi -c 3' to set compute exclusive mode
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:349) Selecting from 1 GPUs
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:364) cudaSetDevice(0): Tesla P100-PCIE-16GB	free:16017M, used:263M, total:16280M, free/total:0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:411) Trying to select device: 0 (automatically), mem_ratio: 0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:430) Success selecting device 0 free mem ratio: 0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:FinalizeActiveGpu():cu-device.cc:284) The active GPU is [0]: Tesla P100-PCIE-16GB	free:15953M, used:327M, total:16280M, free/total:0.979915 version 6.0
nnet-concat exp/dnn4_pretrain-dbn/final.feature_transform exp/dnn4_pretrain-dbn/2.dbn - 
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:53) Reading exp/dnn4_pretrain-dbn/final.feature_transform
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:65) Concatenating exp/dnn4_pretrain-dbn/2.dbn
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:82) Written model to -
copy-feats scp:exp/dnn4_pretrain-dbn/train.scp.10k ark:- 
LOG (copy-feats[5.5.286~1-b96ca]:main():copy-feats.cc:143) Copied 8314 feature matrices.
LOG (nnet-forward[5.5.286~1-b96ca]:main():nnet-forward.cc:192) Done 8314 files in 0.268533min, (fps 97525)
LOG (compute-cmvn-stats[5.5.286~1-b96ca]:main():compute-cmvn-stats.cc:168) Wrote global CMVN stats to standard output
LOG (compute-cmvn-stats[5.5.286~1-b96ca]:main():compute-cmvn-stats.cc:171) Done accumulating CMVN stats for 8314 utterances; 0 had errors.
LOG (cmvn-to-nnet[5.5.286~1-b96ca]:main():cmvn-to-nnet.cc:114) Written cmvn in 'nnet1' model to: exp/dnn4_pretrain-dbn/3.cmvn
initializing 'exp/dnn4_pretrain-dbn/3.rbm.init'
pretraining 'exp/dnn4_pretrain-dbn/3.rbm' (lrate 0.4, iters 20)
# appending RBM to exp/dnn4_pretrain-dbn/3.dbn
nnet-concat exp/dnn4_pretrain-dbn/2.dbn 'rbm-convert-to-nnet exp/dnn4_pretrain-dbn/3.rbm - |' exp/dnn4_pretrain-dbn/3.dbn 
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:53) Reading exp/dnn4_pretrain-dbn/2.dbn
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:65) Concatenating rbm-convert-to-nnet exp/dnn4_pretrain-dbn/3.rbm - |
rbm-convert-to-nnet exp/dnn4_pretrain-dbn/3.rbm - 
LOG (rbm-convert-to-nnet[5.5.286~1-b96ca]:main():rbm-convert-to-nnet.cc:69) Written model to -
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:82) Written model to exp/dnn4_pretrain-dbn/3.dbn

# PRE-TRAINING RBM LAYER 4
# computing cmvn stats 'exp/dnn4_pretrain-dbn/4.cmvn' for RBM initialization
WARNING (nnet-forward[5.5.286~1-b96ca]:SelectGpuId():cu-device.cc:221) Not in compute-exclusive mode.  Suggestion: use 'nvidia-smi -c 3' to set compute exclusive mode
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:349) Selecting from 1 GPUs
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:364) cudaSetDevice(0): Tesla P100-PCIE-16GB	free:16017M, used:263M, total:16280M, free/total:0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:411) Trying to select device: 0 (automatically), mem_ratio: 0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:430) Success selecting device 0 free mem ratio: 0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:FinalizeActiveGpu():cu-device.cc:284) The active GPU is [0]: Tesla P100-PCIE-16GB	free:15953M, used:327M, total:16280M, free/total:0.979915 version 6.0
nnet-concat exp/dnn4_pretrain-dbn/final.feature_transform exp/dnn4_pretrain-dbn/3.dbn - 
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:53) Reading exp/dnn4_pretrain-dbn/final.feature_transform
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:65) Concatenating exp/dnn4_pretrain-dbn/3.dbn
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:82) Written model to -
copy-feats scp:exp/dnn4_pretrain-dbn/train.scp.10k ark:- 
LOG (copy-feats[5.5.286~1-b96ca]:main():copy-feats.cc:143) Copied 8314 feature matrices.
LOG (nnet-forward[5.5.286~1-b96ca]:main():nnet-forward.cc:192) Done 8314 files in 0.277358min, (fps 94421.8)
LOG (compute-cmvn-stats[5.5.286~1-b96ca]:main():compute-cmvn-stats.cc:168) Wrote global CMVN stats to standard output
LOG (compute-cmvn-stats[5.5.286~1-b96ca]:main():compute-cmvn-stats.cc:171) Done accumulating CMVN stats for 8314 utterances; 0 had errors.
LOG (cmvn-to-nnet[5.5.286~1-b96ca]:main():cmvn-to-nnet.cc:114) Written cmvn in 'nnet1' model to: exp/dnn4_pretrain-dbn/4.cmvn
initializing 'exp/dnn4_pretrain-dbn/4.rbm.init'
pretraining 'exp/dnn4_pretrain-dbn/4.rbm' (lrate 0.4, iters 20)
# appending RBM to exp/dnn4_pretrain-dbn/4.dbn
nnet-concat exp/dnn4_pretrain-dbn/3.dbn 'rbm-convert-to-nnet exp/dnn4_pretrain-dbn/4.rbm - |' exp/dnn4_pretrain-dbn/4.dbn 
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:53) Reading exp/dnn4_pretrain-dbn/3.dbn
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:65) Concatenating rbm-convert-to-nnet exp/dnn4_pretrain-dbn/4.rbm - |
rbm-convert-to-nnet exp/dnn4_pretrain-dbn/4.rbm - 
LOG (rbm-convert-to-nnet[5.5.286~1-b96ca]:main():rbm-convert-to-nnet.cc:69) Written model to -
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:82) Written model to exp/dnn4_pretrain-dbn/4.dbn

# PRE-TRAINING RBM LAYER 5
# computing cmvn stats 'exp/dnn4_pretrain-dbn/5.cmvn' for RBM initialization
WARNING (nnet-forward[5.5.286~1-b96ca]:SelectGpuId():cu-device.cc:221) Not in compute-exclusive mode.  Suggestion: use 'nvidia-smi -c 3' to set compute exclusive mode
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:349) Selecting from 1 GPUs
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:364) cudaSetDevice(0): Tesla P100-PCIE-16GB	free:16017M, used:263M, total:16280M, free/total:0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:411) Trying to select device: 0 (automatically), mem_ratio: 0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:430) Success selecting device 0 free mem ratio: 0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:FinalizeActiveGpu():cu-device.cc:284) The active GPU is [0]: Tesla P100-PCIE-16GB	free:15953M, used:327M, total:16280M, free/total:0.979915 version 6.0
nnet-concat exp/dnn4_pretrain-dbn/final.feature_transform exp/dnn4_pretrain-dbn/4.dbn - 
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:53) Reading exp/dnn4_pretrain-dbn/final.feature_transform
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:65) Concatenating exp/dnn4_pretrain-dbn/4.dbn
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:82) Written model to -
copy-feats scp:exp/dnn4_pretrain-dbn/train.scp.10k ark:- 
LOG (copy-feats[5.5.286~1-b96ca]:main():copy-feats.cc:143) Copied 8314 feature matrices.
LOG (nnet-forward[5.5.286~1-b96ca]:main():nnet-forward.cc:192) Done 8314 files in 0.290977min, (fps 90002.6)
LOG (compute-cmvn-stats[5.5.286~1-b96ca]:main():compute-cmvn-stats.cc:168) Wrote global CMVN stats to standard output
LOG (compute-cmvn-stats[5.5.286~1-b96ca]:main():compute-cmvn-stats.cc:171) Done accumulating CMVN stats for 8314 utterances; 0 had errors.
LOG (cmvn-to-nnet[5.5.286~1-b96ca]:main():cmvn-to-nnet.cc:114) Written cmvn in 'nnet1' model to: exp/dnn4_pretrain-dbn/5.cmvn
initializing 'exp/dnn4_pretrain-dbn/5.rbm.init'
pretraining 'exp/dnn4_pretrain-dbn/5.rbm' (lrate 0.4, iters 20)
# appending RBM to exp/dnn4_pretrain-dbn/5.dbn
nnet-concat exp/dnn4_pretrain-dbn/4.dbn 'rbm-convert-to-nnet exp/dnn4_pretrain-dbn/5.rbm - |' exp/dnn4_pretrain-dbn/5.dbn 
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:53) Reading exp/dnn4_pretrain-dbn/4.dbn
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:65) Concatenating rbm-convert-to-nnet exp/dnn4_pretrain-dbn/5.rbm - |
rbm-convert-to-nnet exp/dnn4_pretrain-dbn/5.rbm - 
LOG (rbm-convert-to-nnet[5.5.286~1-b96ca]:main():rbm-convert-to-nnet.cc:69) Written model to -
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:82) Written model to exp/dnn4_pretrain-dbn/5.dbn

# PRE-TRAINING RBM LAYER 6
# computing cmvn stats 'exp/dnn4_pretrain-dbn/6.cmvn' for RBM initialization
WARNING (nnet-forward[5.5.286~1-b96ca]:SelectGpuId():cu-device.cc:221) Not in compute-exclusive mode.  Suggestion: use 'nvidia-smi -c 3' to set compute exclusive mode
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:349) Selecting from 1 GPUs
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:364) cudaSetDevice(0): Tesla P100-PCIE-16GB	free:16017M, used:263M, total:16280M, free/total:0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:411) Trying to select device: 0 (automatically), mem_ratio: 0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:430) Success selecting device 0 free mem ratio: 0.983846
LOG (nnet-forward[5.5.286~1-b96ca]:FinalizeActiveGpu():cu-device.cc:284) The active GPU is [0]: Tesla P100-PCIE-16GB	free:15953M, used:327M, total:16280M, free/total:0.979915 version 6.0
nnet-concat exp/dnn4_pretrain-dbn/final.feature_transform exp/dnn4_pretrain-dbn/5.dbn - 
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:53) Reading exp/dnn4_pretrain-dbn/final.feature_transform
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:65) Concatenating exp/dnn4_pretrain-dbn/5.dbn
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:82) Written model to -
copy-feats scp:exp/dnn4_pretrain-dbn/train.scp.10k ark:- 
LOG (copy-feats[5.5.286~1-b96ca]:main():copy-feats.cc:143) Copied 8314 feature matrices.
LOG (nnet-forward[5.5.286~1-b96ca]:main():nnet-forward.cc:192) Done 8314 files in 0.302198min, (fps 86660.7)
LOG (compute-cmvn-stats[5.5.286~1-b96ca]:main():compute-cmvn-stats.cc:168) Wrote global CMVN stats to standard output
LOG (compute-cmvn-stats[5.5.286~1-b96ca]:main():compute-cmvn-stats.cc:171) Done accumulating CMVN stats for 8314 utterances; 0 had errors.
LOG (cmvn-to-nnet[5.5.286~1-b96ca]:main():cmvn-to-nnet.cc:114) Written cmvn in 'nnet1' model to: exp/dnn4_pretrain-dbn/6.cmvn
initializing 'exp/dnn4_pretrain-dbn/6.rbm.init'
pretraining 'exp/dnn4_pretrain-dbn/6.rbm' (lrate 0.4, iters 20)
# appending RBM to exp/dnn4_pretrain-dbn/6.dbn
nnet-concat exp/dnn4_pretrain-dbn/5.dbn 'rbm-convert-to-nnet exp/dnn4_pretrain-dbn/6.rbm - |' exp/dnn4_pretrain-dbn/6.dbn 
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:53) Reading exp/dnn4_pretrain-dbn/5.dbn
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:65) Concatenating rbm-convert-to-nnet exp/dnn4_pretrain-dbn/6.rbm - |
rbm-convert-to-nnet exp/dnn4_pretrain-dbn/6.rbm - 
LOG (rbm-convert-to-nnet[5.5.286~1-b96ca]:main():rbm-convert-to-nnet.cc:69) Written model to -
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:82) Written model to exp/dnn4_pretrain-dbn/6.dbn

# REPORT
# RBM pre-training progress (line per-layer)
exp/dnn4_pretrain-dbn/log/rbm.1.log:progress: [63.1577 56.0671 54.617 53.8698 53.4386 53.2002 53.0266 52.9017 52.7968 52.7373 52.6892 52.6216 52.6631 52.6625 52.641 52.6392 52.6441 52.6503 52.6212 52.6429 52.6205 52.5959 52.5952 52.5981 52.6001 52.5757 52.5902 52.5757 52.5594 52.5631 52.5505 52.5453 52.5345 52.5397 ]
exp/dnn4_pretrain-dbn/log/rbm.2.log:progress: [6.65538 5.45121 5.34659 5.29056 5.24244 5.19856 5.15616 5.12008 5.08276 5.05056 5.01722 4.99418 4.99765 4.99796 4.99989 4.99913 5.00225 ]
exp/dnn4_pretrain-dbn/log/rbm.3.log:progress: [5.88282 4.39077 4.29284 4.25304 4.21841 4.18954 4.15997 4.13475 4.10783 4.08641 4.06366 4.0455 4.04857 4.04577 4.04686 4.04531 4.04831 ]
exp/dnn4_pretrain-dbn/log/rbm.4.log:progress: [4.17675 3.27489 3.20905 3.17636 3.15162 3.13143 3.11092 3.09528 3.07767 3.06439 3.04929 3.03929 3.04393 3.04219 3.04495 3.04273 3.04544 ]
exp/dnn4_pretrain-dbn/log/rbm.5.log:progress: [3.92688 2.84843 2.78425 2.76098 2.74362 2.72872 2.71433 2.70133 2.68875 2.67831 2.6671 2.65787 2.66144 2.66023 2.6617 2.66033 2.66351 ]
exp/dnn4_pretrain-dbn/log/rbm.6.log:progress: [2.85426 2.23389 2.18211 2.16237 2.14681 2.13453 2.12179 2.11377 2.10275 2.09545 2.08726 2.0794 2.08387 2.08129 2.08361 2.08154 2.0838 ]

Pre-training finished.
# Removing features tmpdir /tmp/kaldi.0YFS @ 2fbdb5a7a42f
train.ark
# Accounting: time=2707 threads=1
# Ended (code 0) at Wed May  8 14:29:43 UTC 2019, elapsed time 2707 seconds
# steps/nnet/train.sh --feature-transform exp/dnn4_pretrain-dbn/final.feature_transform --dbn exp/dnn4_pretrain-dbn/6.dbn --hid-layers 0 --learn-rate 0.008 data-fmllr-tri3/train_tr90 data-fmllr-tri3/train_cv10 data/lang_test_bg exp/tri3_ali exp/tri3_ali exp/dnn4_pretrain-dbn_dnn 
# Started at Wed May  8 14:29:43 UTC 2019
#
steps/nnet/train.sh --feature-transform exp/dnn4_pretrain-dbn/final.feature_transform --dbn exp/dnn4_pretrain-dbn/6.dbn --hid-layers 0 --learn-rate 0.008 data-fmllr-tri3/train_tr90 data-fmllr-tri3/train_cv10 data/lang_test_bg exp/tri3_ali exp/tri3_ali exp/dnn4_pretrain-dbn_dnn

# INFO
steps/nnet/train.sh : Training Neural Network
	 dir       : exp/dnn4_pretrain-dbn_dnn 
	 Train-set : data-fmllr-tri3/train_tr90 7544, exp/tri3_ali 
	 CV-set    : data-fmllr-tri3/train_cv10 770 exp/tri3_ali 

LOG ([5.5.286~1-b96ca]:main():cuda-gpu-available.cc:60) 

### IS CUDA GPU AVAILABLE? '2fbdb5a7a42f' ###
WARNING ([5.5.286~1-b96ca]:SelectGpuId():cu-device.cc:221) Not in compute-exclusive mode.  Suggestion: use 'nvidia-smi -c 3' to set compute exclusive mode
LOG ([5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:349) Selecting from 1 GPUs
LOG ([5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:364) cudaSetDevice(0): Tesla P100-PCIE-16GB	free:16017M, used:263M, total:16280M, free/total:0.983846
LOG ([5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:411) Trying to select device: 0 (automatically), mem_ratio: 0.983846
LOG ([5.5.286~1-b96ca]:SelectGpuIdAuto():cu-device.cc:430) Success selecting device 0 free mem ratio: 0.983846
LOG ([5.5.286~1-b96ca]:FinalizeActiveGpu():cu-device.cc:284) The active GPU is [0]: Tesla P100-PCIE-16GB	free:15953M, used:327M, total:16280M, free/total:0.979915 version 6.0
### HURRAY, WE GOT A CUDA GPU FOR COMPUTATION!!! ##

### Testing CUDA setup with a small computation (setup = cuda-toolkit + gpu-driver + kaldi):
### Test OK!

# PREPARING ALIGNMENTS
Using PDF targets from dirs 'exp/tri3_ali' 'exp/tri3_ali'
hmm-info exp/tri3_ali/final.mdl 
copy-transition-model --binary=false exp/tri3_ali/final.mdl exp/dnn4_pretrain-dbn_dnn/final.mdl 
LOG (copy-transition-model[5.5.286~1-b96ca]:main():copy-transition-model.cc:62) Copied transition model.

# PREPARING FEATURES
# re-saving features to local disk,
copy-feats --compress=true scp:data-fmllr-tri3/train_tr90/feats.scp ark,scp:/tmp/kaldi.llpS/train.ark,exp/dnn4_pretrain-dbn_dnn/train_sorted.scp 
LOG (copy-feats[5.5.286~1-b96ca]:main():copy-feats.cc:143) Copied 7544 feature matrices.
copy-feats --compress=true scp:data-fmllr-tri3/train_cv10/feats.scp ark,scp:/tmp/kaldi.llpS/cv.ark,exp/dnn4_pretrain-dbn_dnn/cv.scp 
LOG (copy-feats[5.5.286~1-b96ca]:main():copy-feats.cc:143) Copied 770 feature matrices.
# importing feature settings from dir 'exp/dnn4_pretrain-dbn'
# cmvn_opts='' delta_opts='' ivector_dim=''
# 'apply-cmvn' is not used,
feat-to-dim 'ark:copy-feats scp:exp/dnn4_pretrain-dbn_dnn/train.scp.10k ark:- |' - 
copy-feats scp:exp/dnn4_pretrain-dbn_dnn/train.scp.10k ark:- 
WARNING (feat-to-dim[5.5.286~1-b96ca]:Close():kaldi-io.cc:515) Pipe copy-feats scp:exp/dnn4_pretrain-dbn_dnn/train.scp.10k ark:- | had nonzero return status 36096
# feature dim : 40 (input of 'feature_transform')
# importing 'feature_transform' from 'exp/dnn4_pretrain-dbn/final.feature_transform'

### Showing the final 'feature_transform':
nnet-info exp/dnn4_pretrain-dbn_dnn/imported_final.feature_transform 
num-components 3
input-dim 40
output-dim 440
number-of-parameters 0.00088 millions
component 1 : <Splice>, input-dim 40, output-dim 440, 
  frame_offsets [ -5 -4 -3 -2 -1 0 1 2 3 4 5 ]
component 2 : <AddShift>, input-dim 440, output-dim 440, 
  shift_data ( min -0.142944, max 0.230102, mean 0.00477159, stddev 0.0441806, skewness 2.40504, kurtosis 14.063 ) , lr-coef 0
component 3 : <Rescale>, input-dim 440, output-dim 440, 
  scale_data ( min 0.260659, max 1.03973, mean 0.771155, stddev 0.181016, skewness -0.570236, kurtosis -0.0180144 ) , lr-coef 0
LOG (nnet-info[5.5.286~1-b96ca]:main():nnet-info.cc:57) Printed info about exp/dnn4_pretrain-dbn_dnn/imported_final.feature_transform
###

# NN-INITIALIZATION
# getting input/output dims :
feat-to-dim 'ark:copy-feats scp:exp/dnn4_pretrain-dbn_dnn/train.scp.10k ark:- | nnet-forward "nnet-concat exp/dnn4_pretrain-dbn_dnn/final.feature_transform '\''exp/dnn4_pretrain-dbn/6.dbn'\'' -|" ark:- ark:- |' - 
copy-feats scp:exp/dnn4_pretrain-dbn_dnn/train.scp.10k ark:- 
nnet-forward "nnet-concat exp/dnn4_pretrain-dbn_dnn/final.feature_transform 'exp/dnn4_pretrain-dbn/6.dbn' -|" ark:- ark:- 
LOG (nnet-forward[5.5.286~1-b96ca]:SelectGpuId():cu-device.cc:146) Manually selected to compute on CPU.
nnet-concat exp/dnn4_pretrain-dbn_dnn/final.feature_transform exp/dnn4_pretrain-dbn/6.dbn - 
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:53) Reading exp/dnn4_pretrain-dbn_dnn/final.feature_transform
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:65) Concatenating exp/dnn4_pretrain-dbn/6.dbn
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:82) Written model to -
WARNING (feat-to-dim[5.5.286~1-b96ca]:Close():kaldi-io.cc:515) Pipe copy-feats scp:exp/dnn4_pretrain-dbn_dnn/train.scp.10k ark:- | nnet-forward "nnet-concat exp/dnn4_pretrain-dbn_dnn/final.feature_transform 'exp/dnn4_pretrain-dbn/6.dbn' -|" ark:- ark:- | had nonzero return status 36096
# genrating network prototype exp/dnn4_pretrain-dbn_dnn/nnet.proto
# initializing the NN 'exp/dnn4_pretrain-dbn_dnn/nnet.proto' -> 'exp/dnn4_pretrain-dbn_dnn/nnet.init'
nnet-initialize --seed=777 exp/dnn4_pretrain-dbn_dnn/nnet.proto exp/dnn4_pretrain-dbn_dnn/nnet.init 
VLOG[1] (nnet-initialize[5.5.286~1-b96ca]:Init():nnet-nnet.cc:314) <AffineTransform> <InputDim> 1024 <OutputDim> 488 <BiasMean> 0.000000 <BiasRange> 0.000000 <ParamStddev> 0.127294
VLOG[1] (nnet-initialize[5.5.286~1-b96ca]:Init():nnet-nnet.cc:314) <Softmax> <InputDim> 488 <OutputDim> 488
VLOG[1] (nnet-initialize[5.5.286~1-b96ca]:Init():nnet-nnet.cc:314) </NnetProto>
LOG (nnet-initialize[5.5.286~1-b96ca]:main():nnet-initialize.cc:63) Written initialized model to exp/dnn4_pretrain-dbn_dnn/nnet.init
nnet-concat exp/dnn4_pretrain-dbn/6.dbn exp/dnn4_pretrain-dbn_dnn/nnet.init exp/dnn4_pretrain-dbn_dnn/nnet_dbn_dnn.init 
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:53) Reading exp/dnn4_pretrain-dbn/6.dbn
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:65) Concatenating exp/dnn4_pretrain-dbn_dnn/nnet.init
LOG (nnet-concat[5.5.286~1-b96ca]:main():nnet-concat.cc:82) Written model to exp/dnn4_pretrain-dbn_dnn/nnet_dbn_dnn.init

# RUNNING THE NN-TRAINING SCHEDULER
steps/nnet/train_scheduler.sh --feature-transform exp/dnn4_pretrain-dbn_dnn/final.feature_transform --learn-rate 0.008 exp/dnn4_pretrain-dbn_dnn/nnet_dbn_dnn.init ark:copy-feats scp:exp/dnn4_pretrain-dbn_dnn/train.scp ark:- | ark:copy-feats scp:exp/dnn4_pretrain-dbn_dnn/cv.scp ark:- | ark:ali-to-pdf exp/tri3_ali/final.mdl "ark:gunzip -c exp/tri3_ali/ali.*.gz |" ark:- | ali-to-post ark:- ark:- | ark:ali-to-pdf exp/tri3_ali/final.mdl "ark:gunzip -c exp/tri3_ali/ali.*.gz |" ark:- | ali-to-post ark:- ark:- | exp/dnn4_pretrain-dbn_dnn
CROSSVAL PRERUN AVG.LOSS 6.5520 (Xent),
ITERATION 01: TRAIN AVG.LOSS 0.8205, (lrate0.008), CROSSVAL AVG.LOSS 0.9513, nnet accepted (nnet_dbn_dnn_iter01_learnrate0.008_tr0.8205_cv0.9513)
ITERATION 02: TRAIN AVG.LOSS 0.5747, (lrate0.008), CROSSVAL AVG.LOSS 0.9325, nnet accepted (nnet_dbn_dnn_iter02_learnrate0.008_tr0.5747_cv0.9325)
ITERATION 03: TRAIN AVG.LOSS 0.4965, (lrate0.008), CROSSVAL AVG.LOSS 0.9442, nnet rejected (nnet_dbn_dnn_iter03_learnrate0.008_tr0.4965_cv0.9442_rejected)
ITERATION 04: TRAIN AVG.LOSS 0.4789, (lrate0.004), CROSSVAL AVG.LOSS 0.8767, nnet accepted (nnet_dbn_dnn_iter04_learnrate0.004_tr0.4789_cv0.8767)
ITERATION 05: TRAIN AVG.LOSS 0.4358, (lrate0.002), CROSSVAL AVG.LOSS 0.8345, nnet accepted (nnet_dbn_dnn_iter05_learnrate0.002_tr0.4358_cv0.8345)
ITERATION 06: TRAIN AVG.LOSS 0.4162, (lrate0.001), CROSSVAL AVG.LOSS 0.8022, nnet accepted (nnet_dbn_dnn_iter06_learnrate0.001_tr0.4162_cv0.8022)
ITERATION 07: TRAIN AVG.LOSS 0.4073, (lrate0.0005), CROSSVAL AVG.LOSS 0.7802, nnet accepted (nnet_dbn_dnn_iter07_learnrate0.0005_tr0.4073_cv0.7802)
ITERATION 08: TRAIN AVG.LOSS 0.4033, (lrate0.00025), CROSSVAL AVG.LOSS 0.7652, nnet accepted (nnet_dbn_dnn_iter08_learnrate0.00025_tr0.4033_cv0.7652)
ITERATION 09: TRAIN AVG.LOSS 0.4016, (lrate0.000125), CROSSVAL AVG.LOSS 0.7554, nnet accepted (nnet_dbn_dnn_iter09_learnrate0.000125_tr0.4016_cv0.7554)
ITERATION 10: TRAIN AVG.LOSS 0.4008, (lrate6.25e-05), CROSSVAL AVG.LOSS 0.7496, nnet accepted (nnet_dbn_dnn_iter10_learnrate6.25e-05_tr0.4008_cv0.7496)
ITERATION 11: TRAIN AVG.LOSS 0.4003, (lrate3.125e-05), CROSSVAL AVG.LOSS 0.7467, nnet accepted (nnet_dbn_dnn_iter11_learnrate3.125e-05_tr0.4003_cv0.7467)
ITERATION 12: TRAIN AVG.LOSS 0.3999, (lrate1.5625e-05), CROSSVAL AVG.LOSS 0.7456, nnet accepted (nnet_dbn_dnn_iter12_learnrate1.5625e-05_tr0.3999_cv0.7456)
ITERATION 13: TRAIN AVG.LOSS 0.3996, (lrate7.8125e-06), CROSSVAL AVG.LOSS 0.7452, nnet accepted (nnet_dbn_dnn_iter13_learnrate7.8125e-06_tr0.3996_cv0.7452)
finished, too small rel. improvement 0.000523073
steps/nnet/train_scheduler.sh: Succeeded training the Neural Network : 'exp/dnn4_pretrain-dbn_dnn/final.nnet'
steps/nnet/train.sh: Successfuly finished. 'exp/dnn4_pretrain-dbn_dnn'
steps/nnet/decode.sh --nj 20 --cmd run.pl --mem 4G --acwt 0.2 exp/tri3/graph data-fmllr-tri3/test exp/dnn4_pretrain-dbn_dnn/decode_test
# Removing features tmpdir /tmp/kaldi.llpS @ 2fbdb5a7a42f
cv.ark
train.ark
# Accounting: time=299 threads=1
# Ended (code 0) at Wed May  8 14:34:42 UTC 2019, elapsed time 299 seconds
steps/nnet/align.sh --nj 20 --cmd run.pl --mem 2G data-fmllr-tri3/train data/lang_test_bg exp/dnn4_pretrain-dbn_dnn exp/dnn4_pretrain-dbn_dnn_ali
steps/nnet/align.sh: aligning data 'data-fmllr-tri3/train' using nnet/model 'exp/dnn4_pretrain-dbn_dnn', putting alignments in 'exp/dnn4_pretrain-dbn_dnn_ali'
steps/nnet/align.sh: done aligning data.
steps/nnet/make_denlats.sh --nj 20 --cmd run.pl --mem 4G --acwt 0.2 --lattice-beam 10.0 --beam 18.0 data-fmllr-tri3/train data/lang_test_bg exp/dnn4_pretrain-dbn_dnn exp/dnn4_pretrain-dbn_dnn_denlats
Making unigram grammar FST in exp/dnn4_pretrain-dbn_dnn_denlats/lang_test_bg
Compiling decoding graph in exp/dnn4_pretrain-dbn_dnn_denlats/dengraph
tree-info exp/dnn4_pretrain-dbn_dnn/tree 
tree-info exp/dnn4_pretrain-dbn_dnn/tree 
make-h-transducer --disambig-syms-out=exp/dnn4_pretrain-dbn_dnn_denlats/dengraph/disambig_tid.int --transition-scale=1.0 exp/dnn4_pretrain-dbn_dnn_denlats/lang_test_bg/tmp/ilabels_3_1 exp/dnn4_pretrain-dbn_dnn/tree exp/dnn4_pretrain-dbn_dnn/final.mdl 
fsttablecompose exp/dnn4_pretrain-dbn_dnn_denlats/dengraph/Ha.fst exp/dnn4_pretrain-dbn_dnn_denlats/lang_test_bg/tmp/CLG_3_1.fst 
fstdeterminizestar --use-log=true 
fstrmsymbols exp/dnn4_pretrain-dbn_dnn_denlats/dengraph/disambig_tid.int 
fstrmepslocal 
fstminimizeencoded 
fstisstochastic exp/dnn4_pretrain-dbn_dnn_denlats/dengraph/HCLGa.fst 
0.000366448 -0.000383228
add-self-loops --self-loop-scale=0.1 --reorder=true exp/dnn4_pretrain-dbn_dnn/final.mdl exp/dnn4_pretrain-dbn_dnn_denlats/dengraph/HCLGa.fst 
steps/nnet/make_denlats.sh: generating denlats from data 'data-fmllr-tri3/train', putting lattices in 'exp/dnn4_pretrain-dbn_dnn_denlats'
steps/nnet/make_denlats.sh: done generating denominator lattices.
steps/nnet/train_mpe.sh --cmd run.pl --gpu 1 --num-iters 6 --acwt 0.2 --do-smbr true data-fmllr-tri3/train data/lang_test_bg exp/dnn4_pretrain-dbn_dnn exp/dnn4_pretrain-dbn_dnn_ali exp/dnn4_pretrain-dbn_dnn_denlats exp/dnn4_pretrain-dbn_dnn_smbr
Pass 1 (learnrate 0.00001)
 TRAINING FINISHED; Time taken = 2.33172 min; processed 11231.5 frames per second.
 Done 8314 files, 0 with no reference alignments, 0 with no lattices, 0 with other errors.
 Overall average frame-accuracy is 0.994879 over 1571321 frames.
Pass 2 (learnrate 1e-05)
 TRAINING FINISHED; Time taken = 2.44438 min; processed 10713.8 frames per second.
 Done 8314 files, 0 with no reference alignments, 0 with no lattices, 0 with other errors.
 Overall average frame-accuracy is 0.995404 over 1571321 frames.
Pass 3 (learnrate 1e-05)
 TRAINING FINISHED; Time taken = 2.57863 min; processed 10156.1 frames per second.
 Done 8314 files, 0 with no reference alignments, 0 with no lattices, 0 with other errors.
 Overall average frame-accuracy is 0.995661 over 1571321 frames.
Pass 4 (learnrate 1e-05)
 TRAINING FINISHED; Time taken = 2.66095 min; processed 9841.87 frames per second.
 Done 8314 files, 0 with no reference alignments, 0 with no lattices, 0 with other errors.
 Overall average frame-accuracy is 0.99574 over 1571321 frames.
Pass 5 (learnrate 1e-05)
 TRAINING FINISHED; Time taken = 2.86928 min; processed 9127.28 frames per second.
 Done 8314 files, 0 with no reference alignments, 0 with no lattices, 0 with other errors.
 Overall average frame-accuracy is 0.995778 over 1571321 frames.
Pass 6 (learnrate 1e-05)
 TRAINING FINISHED; Time taken = 2.79745 min; processed 9361.62 frames per second.
 Done 8314 files, 0 with no reference alignments, 0 with no lattices, 0 with other errors.
 Overall average frame-accuracy is 0.995805 over 1571321 frames.
MPE/sMBR training finished
Re-estimating priors by forwarding 10k utterances from training set.
steps/nnet/make_priors.sh --cmd run.pl --mem 2G --nj 20 data-fmllr-tri3/train exp/dnn4_pretrain-dbn_dnn_smbr
Accumulating prior stats by forwarding 'data-fmllr-tri3/train' with 'exp/dnn4_pretrain-dbn_dnn_smbr'
Succeeded creating prior counts 'exp/dnn4_pretrain-dbn_dnn_smbr/prior_counts' from 'data-fmllr-tri3/train'
steps/nnet/train_mpe.sh: Done. 'exp/dnn4_pretrain-dbn_dnn_smbr'
steps/nnet/decode.sh --nj 20 --cmd run.pl --mem 4G --nnet exp/dnn4_pretrain-dbn_dnn_smbr/1.nnet --acwt 0.2 exp/tri3/graph data-fmllr-tri3/test exp/dnn4_pretrain-dbn_dnn_smbr/decode_test_it1
steps/nnet/decode.sh --nj 20 --cmd run.pl --mem 4G --nnet exp/dnn4_pretrain-dbn_dnn_smbr/6.nnet --acwt 0.2 exp/tri3/graph data-fmllr-tri3/test exp/dnn4_pretrain-dbn_dnn_smbr/decode_test_it6
Success
