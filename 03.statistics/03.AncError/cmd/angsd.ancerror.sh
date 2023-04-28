#!/bin/bash
export BAMLIST=$1
angsd \
	-b $BAMLIST \
	-minQ 20 -minMapQ 25 \
	-doAncError 2 \
	-out $OUTPREFIX \
	-anc ${OUTGROUP}.fa \
	-ref ${PERFECT}.fa

#one sample name per line in INDLIST file, must be consistent with the BAMLIST
Rscript PATH-TO-ANGSD/R/estError.R file=${OUTPREFIX}.ancError indNames=$INDLIST
