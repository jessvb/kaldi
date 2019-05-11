#!/bin/bash

if [ $# -ne 1 ]; then
	echo "usage: $0 phone_file"
	exit 1
fi

if [ $1 == "phones.txt" ]; then
	echo "Phone file name could not be phones.txt"
	exit 1
fi

if [ ! -f $1 ]; then
	echo "$1: no such file"
	exit 1
fi

if [ -f phones.txt ]; then 
	rm phones.txt
fi

echo "<eps> 0" >> phones.txt
let i=1
while read line 
do
	echo ${line} ${i} >> phones.txt
	let i=${i}+1
done < $1

chmod 777 phones.txt
