#!/bin/bash

let subset=1
for x in ${GINA300_DATA_ROOT}/waves/*	
do
	if [ ${subset} -gt ${CORPUS_SUBSET} ]; then
		break;
	else
		let subset=${subset}+1
	fi
	echo "`basename $x | sed "s/\.wav//g"`"
done
