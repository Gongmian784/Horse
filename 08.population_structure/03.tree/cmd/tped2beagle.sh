#!/bin/bash
mkdir ../data
# filter
plink 	--keep $SAMPLELIST --maf 0.01 --geno 0.1 \
	--bfile ../../../04.variant/01.pseudo-haploid/cmd/chrAuto.tv \
	--horse --make-bed \
	--out ../data/chrAuto.tv.maf0.01
# $SAMPLELIST is a sample ID file using the first two columns of bim file formated by PLINK.

# bed to tped
plink --bfile ../data/chrAuto.tv.maf0.01 \
	--horse --recode transpose \
	--out ../data/$1

python tped2beagle.py \
	--tped ../data/${1}.tped \
	--tfam ../data/${1}.tfam \
	--outfmt beagle --outprefix ../data/${1}
