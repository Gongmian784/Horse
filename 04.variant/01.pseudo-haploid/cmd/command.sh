#!/bin/bash
# Pseudo-haploid calling
for i in `cat $SAMPLELIST` ; do ls ../../../02.rescale.trim/merge/nuclear/${i}.nuclear.bam ; done > select.bamlist
mkdir ..out ../tped 
# $SAMPLELIST: a file of sample ID selected, one per line.
for i in `cat ../../../00.prepare/reference/auto.10m.region` ; do bash angsd.dohaplocall.sh $i ; done

# Convert tped to bed
bash tped2bed.sh $SAMPLELIST
