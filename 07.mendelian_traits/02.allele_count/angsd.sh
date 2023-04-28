#!/bin/sh
angsd \
	-b select.bamlist \
	-minQ 20 -minMapQ 25 -remove_bads 1 -uniqueOnly 1 \
	-C 50 -ref $REF \
	-only_proper_pairs 0 \
	-minInd 1 \
	-doMajorMinor 1 -doMaf 1 -GL 2 -beagleProb 1 -doPost 1 \
	-doCounts 1 -dumpCounts 4 \
	-rf mendelian.region \
	-out mendelian
