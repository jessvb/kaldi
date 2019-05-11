#!/bin/bash

# Pick up missing words in lexicon.txt from transcrp.tbl

#trn="/export/LDC97S63/cmu_kids/tables/transcrp.tbl"
trn="./transcrp.tbl"
lexicon="./lexicon.txt"
lex_tmp="./lexicon.tmp"
oov="./oov.txt"

cat ${trn} |\
	sed "s/[^A-Z]/ /g" |\
	sed "s/ \+/\n/g" |\
	sed "/^$/d" |\
	tr '\n' ' ' |\
	java Pickoov > ${oov}

cat ${lexicon} |\
	sed "s/[\t ]\+/\n/g" > ${lex_tmp}

#while read line 
#do
#	word=`cat ${lex_tmp} |\
#		grep -m 1 -w ${line}`
#	if [ -z ${word} ]; then
#		echo ${line} >> missing_phones.txt
#	fi
#done < ${oov}

# format trn file
cat ${trn} |\
	sed "s/\// \/ /g" |\
	sed "s/,/ /g" |\
	sed "s/\[/ \[/g" |\
	sed "s/\]/\] /g" > semi_formatted_trn.txt
cat semi_formatted_trn.txt |\
	sed "s/^[^\t ]\+ //g" |\
	sed "s/[a-z]/\u&/g" |\
	text2wfreq |\
	sed "s/ .*//g" > trn_words.txt

while read line 
do
	word=`cat ${lex_tmp} |\
		grep -F -m 1 -w ${line}`
	if [ -z ${word} ]; then
		echo ${line} >> missing_words.tmp
	fi
done < trn_words.txt

cat missing_words.tmp |\
	tr '\n' ' ' |\
	java Pickoov > missing_words.txt

rm missing_words.tmp
rm trn_words.txt
rm ${lex_tmp}
rm ${oov}
