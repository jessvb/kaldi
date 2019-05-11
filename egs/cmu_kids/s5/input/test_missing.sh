#!/bin/bash

if [ $# -ne 2 ]; then
	echo "usage: $0 test_file lexicon_file"
	exit 1
fi

if [ ! -f $1 ]; then
	echo "$1: no such file"
	exit 1
fi

if [ ! -f $2 ]; then
	echo "$2: no such file"
	exit 1
fi

while read line
do
	missing=`cat $2 | grep -m 1 -w "${line}"`
	if [[ ${missing} == "" ]]; then
		echo ${line}
	fi
done < $1
