#!/bin/bash
export chr=$1 #chromosome region
angsd \
	-b $BAMLIST \
	-nThreads 4 \
	-minQ 20 -minMapQ 25 -remove_bads 1 -uniqueOnly 1 -baq 2 \
	-C 50 -ref $REF \
	-only_proper_pairs 0 \
	-minInd $MININD \
	-doMajorMinor 1 -doMaf 1 -GL 2 -beagleProb 1 -doPost 1 \
	-doCounts 1 \
	-r $chr \
	-out ../out/chr$chr
# $BAMLIST: list of bam files selected
# $MININD: minimum individuals available in each site 
# $REF: the reference genome
