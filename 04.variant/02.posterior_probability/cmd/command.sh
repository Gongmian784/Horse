#!/bin/bash
for i in `cat $SAMPLELIST` ; do ls ../../../02.rescale.trim/merge/nuclear/${i}.nuclear.bam ; done > select.bamlist
# $SAMPLELIST: a file of sample ID selected, one per line.
mkdir ../out

#generate posterior probability dataset for each chromosome
for i in {1..31} ; do bash angsd.dopost.sh $i ; done
