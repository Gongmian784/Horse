#!/bin/bash
#filter for biallelic SNP
mkdir ../out
for i in {1..31} X ; do bash hardFilter_mark_snp.sh $i ; done
for i in {1..31} X ; do bash filter_snp.sh $i ; done
