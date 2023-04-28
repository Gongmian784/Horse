#!/bin/bash
mkdir ../out
for i in {1..31} X
do 
	mkdir -p ../tmp/chr$i
	bash genotypeGVCFs.sh $i
done
