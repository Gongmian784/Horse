#!/bin/bash
export SAMPLELIST=$1 
awk '{print $1"\t"$1"\t0\t0\t0\t0"}' $SAMPLELIST > select.tfam
for i in `cat ../../../00.prepare/reference/auto.10m.region`
do
	cat ../tped/chr${i}.tped
done > chrAuto.tped

# tped to bed
plink --tped chrAuto.tped --tfam select.tfam --horse --make-bed --out chrAuto
#rm ../tped/*

# treat transisions
python stat_bim_titv.py chrAuto.bim chrAuto.titv.stat
awk '$4=="tv"{print $1}' chrAuto.titv.stat > chrAuto.tv.sites
plink --bfile chrAuto --extract chrAuto.tv.sites --horse --make-bed --out chrAuto.tv
