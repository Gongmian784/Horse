#!/bin/bash
# filter
plink 	--keep $SAMPLELIST --maf 0.01 --geno 0.1 \
	--bfile ../../04.variant/01.pseudo-haploid/cmd/chrAuto.tv \
	--horse --make-bed \
	--out chrAuto.tv.maf0.01

# prune
plink	--bfile chrAuto.tv.maf0.01 \
	--horse --indep-pairwise 50 10 0.2 --out chrAuto.tv.maf0.01
plink	--bfile chrAuto.tv.maf0.01 \
	--extract chrAuto.tv.maf0.01.prune.in \
	--horse --make-bed --out chrAuto.tv.maf0.01.pruned

# run
#admixture -j5 --cv chrAuto.tv.maf0.01.bed $2
admixture -j5 --cv chrAuto.tv.maf0.01.pruned.bed $2
