#!/bin/bash

# Copyright 2012  Johns Hopkins University (Author: Daniel Povey)
# Apache 2.0.

. ./path.sh # Needed for KALDI_ROOT

if [ $# -ne 1 ]; then
   echo "Argument should be the TIDIGITS directory, see ../run.sh for example."
   exit 1;
fi

tidigits=$1

tmpdir=`pwd`/data/local/data
mkdir -p $tmpdir

## FROM TIMIT:
dir=`pwd`/data/local/data
lmdir=`pwd`/data/local/nist_lm
mkdir -p $dir $lmdir 
local=`pwd`/local
utils=`pwd`/utils
conf=`pwd`/conf

# Note: the .wav files are not in .wav format but "sphere" format (this was
# produced in the days before Windows).

## we WANT our data to have adults + children, not just adults, so ignore the following:
#if [ -d $tidigits/data ]; then
#  rootdir=$tidigits/data/adults
#elif [ -d $tidigits/tidigits ]; then
#  # This is, I think, a modified
#  # version of the format that exists at BUT.
#  rootdir=$tidigits/tidigits
#else
#  echo "Tidigits directory $tidigits does not have expected format."
#fi

## instead, just make the one passed in the rootdir:
rootdir=$tidigits

echo "TEST ls rootdir: "
ls $rootdir

find $rootdir/train -name '*.wav' > $tmpdir/train.flist
n=`cat $tmpdir/train.flist | wc -l`
[ $n -eq 8623 ] || echo "The number of training files $n is not 8623. This means we're not just using adult data :)"
# there are 8623 training data file for ONLY ADULTS

find $rootdir/test -name '*.wav' > $tmpdir/test.flist
n=`cat $tmpdir/test.flist | wc -l`
[ $n -eq 8700 ] || echo "The number of test files $n is not 8700. This means we're not just using adult data :)"
# there are 8700 test data files for ONLY ADULTS

sph2pipe=$KALDI_ROOT/tools/sph2pipe_v2.5/sph2pipe
if [ ! -x $sph2pipe ]; then
   echo "Could not find (or execute) the sph2pipe program at $sph2pipe";
   exit 1;
fi

for x in train test; do
  # get scp file that has utterance-ids and maps to the sphere file.
  cat $tmpdir/$x.flist | perl -ane 'm|/(..)/([1-9zo]+[ab])\.wav| || die "bad line $_"; print "$1_$2 $_"; ' \
   | sort > $tmpdir/${x}_sph.scp
  # turn it into one that has a valid .wav format in the modern sense (i.e. RIFF format, not sphere).
  # This file goes into its final location
  mkdir -p data/$x
  awk '{printf("%s '$sph2pipe' -f wav %s |\n", $1, $2);}' < $tmpdir/${x}_sph.scp > data/$x/wav.scp

  # Now get the "text" file that says what the transcription is.
  cat data/$x/wav.scp |
   perl -ane 'm/^(.._([1-9zo]+)[ab]) / || die; $text = join(" ", split("", $2)); print "$1 $text\n";' \
    <data/$x/wav.scp >$tmpdir/train.text
    #<data/$x/wav.scp >data/$x/text

  # now get the "utt2spk" file that says, for each utterance, the speaker name.
  perl -ane 'm/^((..)_\S+) / || die; print "$1 $2\n"; ' \
    <data/$x/wav.scp >data/$x/utt2spk
  # create the file that maps from speaker to utterance-list.
  utils/utt2spk_to_spk2utt.pl <data/$x/utt2spk >data/$x/spk2utt
done


## TODO: the rest of this is stm stuff from timit. we have to make the stm file for scoring! 
##for x in train dev test; do <-- don't care about dev for tidigits
for x in train test; do
  ## TODO: since TIMIT has a file called train_spk with a list of speaker id's, let's make one too! 
  # note: this is kinda hack-y because we're just using all the speakers from the spk2utt file ;P 
  awk '{print $1}' data/$x/spk2utt > $tmpdir/${x}_spk


  ## replaced ${x}_sph.flist with data/local/data/${x}.flist
  sed -e 's:.*/\(.*\)/\(.*\).\(WAV\|wav\)$:\1_\2:' $tmpdir/${x}.flist \
    > $tmpdir/${x}_sph.uttids
  paste $tmpdir/${x}_sph.uttids $tmpdir/${x}.flist \
    | sort -k1,1 > ${x}_sph.scp

  cat ${x}_sph.scp | awk '{print $1}' > $tmpdir/${x}.uttids

  # Now, Convert the transcripts into our format (no normalization yet)
  # Get the transcripts: each line of the output contains an utterance
  # ID followed by the transcript.
  find $*/{$train_dir,$test_dir} -not \( -iname 'SA*' \) -iname '*.PHN' \
    | grep -f $tmpdir/${x}_spk > $tmpdir/${x}_phn.flist
  sed -e 's:.*/\(.*\)/\(.*\).\(PHN\|phn\)$:\1_\2:' $tmpdir/${x}_phn.flist \
    > $tmpdir/${x}_phn.uttids
  while read line; do
    [ -f $line ] || error_exit "Cannot find transcription file '$line'";
    cut -f3 -d' ' "$line" | tr '\n' ' ' | perl -ape 's: *$:\n:;'
  done < $tmpdir/${x}_phn.flist > $tmpdir/${x}_phn.trans
## TODO: STARTING HERE, I'M CHANGING STUFF TO $TMPDIR/${X} BECAUSE THERE'S AN ERROR...
  paste $tmpdir/${x}_phn.uttids $tmpdir/${x}_phn.trans \
    | sort -k1,1 > $tmpdir/${x}.trans 

  # Do normalization steps.
  cat $tmpdir/${x}.trans | $local/timit_norm_trans.pl -i - -m $conf/phones.60-48-39.map -to 48 | sort > $tmpdir/$x.text || exit 1;

  # Create wav.scp
  awk '{printf("%s '$sph2pipe' -f wav %s |\n", $1, $2);}' < $tmpdir/${x}_sph.scp > $tmpdir/${x}_wav.scp

  # Make the utt2spk and spk2utt files.
  cut -f1 -d'_'  $tmpdir/$x.uttids | paste -d' ' $tmpdir/$x.uttids - > $tmpdir/$x.utt2spk 
  cat $tmpdir/$x.utt2spk | $utils/utt2spk_to_spk2utt.pl > $tmpdir/$x.spk2utt || exit 1;

  # Prepare gender mapping
## TODO: I don't care about gender  
##cat $x.spk2utt | awk '{print $1}' | perl -ane 'chop; m:^.:; $g = lc($&); print "$_ $g\n";' > $x.spk2gender

  # Prepare STM file for sclite:
  wav-to-duration --read-entire-file=true scp:$tmpdir/${x}_wav.scp ark,t:$tmpdir/${x}_dur.ark || exit 1
  awk -v dur=$tmpdir/${x}_dur.ark \
  'BEGIN{
     while(getline < dur) { durH[$1]=$2; }
     print ";; LABEL \"O\" \"Overall\" \"Overall\"";
     print ";; LABEL \"F\" \"Female\" \"Female speakers\"";
     print ";; LABEL \"M\" \"Male\" \"Male speakers\"";
   }
   { wav=$1; spk=wav; sub(/_.*/,"",spk); $1=""; ref=$0;
     gender=(substr(spk,0,1) == "f" ? "F" : "M");
     printf("%s 1 %s 0.0 %f <O,%s> %s\n", wav, spk, durH[wav], gender, ref);
   }
  ' $tmpdir/${x}.text >$tmpdir/${x}.stm || exit 1
echo $tmpdir/${x}.text
echo $tmpdir/${x}.stm
  # Create dummy GLM file for sclite:
  echo ';; empty.glm
  [FAKE]     =>  %HESITATION     / [ ] __ [ ] ;; hesitation token
  ' > $tmpdir/${x}.glm
done

echo "Data preparation succeeded"
