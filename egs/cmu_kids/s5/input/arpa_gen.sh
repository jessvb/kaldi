#!/bin/bash

if [ $# -ne 2 ]; then
	echo "usage: $0 trn_file output_file"
	exit 1
fi

if [ ! -f $1 ]; then
	echo "$1: file does not exist."
	exit 1
fi

if [ -f $2 ]; then 
	rm $2
fi

trn_file=$1
output_file=$2

echo "Preparing arpa file"

cat ${trn_file} |\
	sed "s/^[^ ]\+ //g" > childspeech.txt

cat childspeech.txt | text2wfreq | wfreq2vocab -top 20000 > childspeech.vocab

cat childspeech.txt | text2idngram -vocab childspeech.vocab -idngram  childspeech.idngram

idngram2lm -idngram childspeech.idngram -vocab childspeech.vocab -binary childspeech.binlm

binlm2arpa -binary childspeech.binlm -arpa childspeech.arpa 


cat childspeech.arpa |\
	sed "s/<S>/<s>/g" |\
	sed "s/<\/S>/<\/s>/g" > ${output_file} 

#cat childspeech.arpa |\
#	sed "s/<S>/<s>/g" |\
#	sed "s/<\/S>/<\/s>/g" |\
#	sed "s/[\\]/\\\\\\\\/g" > childspeech.arpa.tmp
#
#let i=1
#while read line 
#do
#	if [ ${i} -gt 48 ]; then 
#		echo "${line}" >> childspeech.arpa.final
#	fi
#	let i=${i}+1
#done < childspeech.arpa.tmp
#
#cat childspeech.arpa.final |\
#	sed "s/[-0-9]\+\.[0-9]\+$//g" > ${output_file}

#mv childspeech.arpa.final ${output_file}

rm childspeech.vocab childspeech.binlm childspeech.idngram childspeech.txt childspeech.arpa 

chmod 777 ${output_file}
echo "Complete preparing arpa file"
