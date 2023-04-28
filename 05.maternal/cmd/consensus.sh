#!/bin/bash
export bam=$1
export name=`basename $1 .mitochondria.*bam`
angsd -doFasta 2 \
    -i $bam \
    -setMinDepth 3 -minQ 25 -minMapQ 25 \
    -only_proper_pairs 0 \
    -explode 1 \
    -doCounts 1 \
    -out ../out/$name
gunzip ../out/${name}.fa.gz
sed -i "s/^>MT/>${name}/g" ../out/${name}.fa
