#!/bin/bash
csvtk join -t -H -f '2;1' $SAMPLELIST $GROUP > pop.cluster
# $SAMPLELIST is a sample ID file using the first two columns of bim file formated by PLINK.
# $GROUP is a file defining the group of each sample, one per line, two columnes formated as "ID GROUP"

# filter
plink 	--keep $SAMPLELIST --maf ${1} \
	--bfile ../../../04.variant/01.pseudo-haploid/cmd/chrAuto.tv \
	--horse --make-bed \
	--out ../data/chrAuto.tv.maf${1}
plink	--bfile chrAuto.tv.maf${1} \
	--horse --freq 'gz' \
	--out ../data/chrAuto.tv.maf${1} \
	--within pop.cluster

# exclude missing sites
zcat ../data/chrAuto.tv.maf${1}.frq.strat.gz | awk '$8>0{print $2}' | uniq -c | sed '1d' > ../data/chrAuto.tv.maf${1}.m.stat
awk -v GROUPNUM=$GROUPNUM "$1>=GROUPNUM" ../data/chrAuto.tv.maf${1}.m.stat | awk '{print $2}' > ../data/chrAuto.tv.maf${1}.m.sites
# $GROUPNUM is the numbers of groups.

#filter
plink	--extract ../data/chrAuto.tv.maf${1}.m.sites \
	--bfile ../data/chrAuto.tv.maf${1} \
	--horse --make-bed --out ../data/chrAuto.tv.maf${1}.m
plink	--bfile ../data/chrAuto.tv.maf${1}.m \
	--horse \
	--freq 'gz' \
	--out ../data/chrAuto.tv.maf${1}.m \
	--within pop.cluster
python plink2treemix.py --infile ../data/chrAuto.tv.maf${1}.m.frq.strat.gz --outfile ../data/chrAuto.tv.maf${1}.m.treemix.gz
