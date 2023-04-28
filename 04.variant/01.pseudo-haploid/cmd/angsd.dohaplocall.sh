#!/bin/bash
export chr=$1 #chromosome region
angsd \
	-b select.bamlist \
	-nThreads 8 \
	-minQ 20 -minMapQ 25 -remove_bads 1 -uniqueOnly 1 -baq 2 \
	-C 50 -ref $REF \
	-only_proper_pairs 0 \
	-minInd 1 \
	-doCounts 1 -dumpCounts 4 \
	-dohaplocall 1 -minMinor 1 \
	-r $chr \
	-out ../out/chr${chr}
# $REF is the reference genome

haploToPlink \
	../out/chr${chr}.haplo.gz ../tped/chr${chr}
# haploToPlink is a software in the directory misc of angsd.

sed -i 's/N N/0 0/g' ../tped/chr${chr}.tped
