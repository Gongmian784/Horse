#!/bin/bash
mkdir ../out
# filter depths and concat chromosomes
for i in {1..31} ; do bash filter.sh $i ; done
bash concat.sh
