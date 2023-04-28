#!/bin/bash
# filter
plink 	--keep $SAMPLELIST --maf 0.01 --geno 0.1 \
	--bfile ../../04.variant/01.pseudo-haploid/cmd/chrAuto.tv \
	--horse --make-bed \
	--out chrAuto.tv.maf0.01
# $SAMPLELIST is a sample ID file using the first two columns of bim file formated by PLINK.

# bed to tped
plink --bfile chrAuto.tv.maf0.01 \
	--horse --recode transpose \
	--out $1

# tped to beagle
python /stor9000/apps/users/NWSUAF/2014010784/script/tped2beagle.py \
	--tped ${1}.tped \
	--tfam ${1}.tfam \
	--outfmt beagle --outprefix ${1}
