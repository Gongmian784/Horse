#!/bin/bash
source ~/.bashrc
export chr=$1
export group=$2
angsd \
	-b ${group}.bamlist \
	-nThreads 1 \
	-minQ 20 -minMapQ 25 -remove_bads 1 -uniqueOnly 1 -baq 2 \
	-C 50 -ref $REF \
	-only_proper_pairs 0 \
	-GL 2 \
	-doSaf 1 \
	-anc ../../../03.statistics/03.AncError/cmd/${OUTGROUP}.fa \
	-r $chr \
	-out ../$group/$chr
