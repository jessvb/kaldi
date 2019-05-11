#!/bin/bash

# Flaten plain_trans.txt

cat plain_trans.txt | sed "s/[0-9]\+\.cut[0-9]//g" | tr " " "\n" > flaten_file
