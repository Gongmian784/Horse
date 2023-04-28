#!/bin/bash
angsd \
    -doAbbababa2 1 -blockSize 10000000 \
    -bam bamlist \
    -sizeFile size.file \
    -r $1 \
    -minQ 20 -minMapQ 25 -remove_bads 1 -uniqueOnly 1 -baq 2 \
    -C 50 -ref $REF \
    -only_proper_pairs 0 \
    -sample 1 \
    -rmTrans 0 \
    -doCounts 1 \
    -out ../out/$1 \
    -useLast 1 \
    -p 1
