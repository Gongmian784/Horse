#!/bin/bash
# outgroup genome
angsd \
	-doFasta 1 \
	-minQ 20 -minMapQ 25 \
	-setMinDepth 8 -setMaxDepth $MAXDEPTHS \
	-only_proper_pairs 0 \
	-C 50 -ref $REF \
	-doCounts 1 \
	-explode 1 \
	-i ../../../02.rescale.trim/merge/nuclear/${OUTGROUP}.nuclear.r.t.s.m.bam \
	-out $OUTGROUP
gunzip ${OUTGROUP}.fa.gz
samtools faidx ${OUTGROUP}.fa

# perfect genome
angsd \
	-doFasta 1 \
	-minQ 20 -minMapQ 25 \
	-setMinDepth 8 -setMaxDepth $MAXDEPTHS \
	-only_proper_pairs 0 \
	-C 50 -ref $REF \
	-doCounts 1 \
	-explode 1 \
	-i ../../../02.rescale.trim/merge/nuclear/${PERFECT}.nuclear.r.t.s.m.bam \
	-out ${PERFECT}
gunzip ${PERFECT}.fa.gz
samtools faidx ${PERFECT}.fa
