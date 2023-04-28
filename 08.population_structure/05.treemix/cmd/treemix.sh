#!/bin/bash
source ~/.bashrc
treemix -i ../data/chrAuto.maf0.01.treemix.gz \
	-global \
	-m ${1} \
	-k 500 \
	-root $OUTGROUP \
	-o ../out/${1}.maf0.01
Rscript treemix.r ../out/${1}.maf0.01 $COLOR
# $COLOR is a file defining colors of each group, one per line formated as "GROUP COLOR"
