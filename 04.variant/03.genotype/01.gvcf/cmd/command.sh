#!/bin/bash
#Produce gvcf files per individual per chromosome
mkdir ../out ; for i in {1..31} X ; do mkdir ../out/chr${chr} ; done
for i in `cat $SAMPLELIST` ; do ls ../../../../02.rescale.trim/merge/nuclear/${i}.nuclear.bam ; done > select.bamlist
# $SAMPLELIST: a file of sample ID selected, one per line.

# GATK haplotypeCaller
for i in {1..31} X
do
	for j in `cat select.bamlist`
	do
		k=`basename $j .nuclear.bam`
		bash haplotypeCaller.sh $i $j $k
	done
done
