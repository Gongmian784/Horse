#!/bin/bash
export bam=${1}
export name=`basename $1 .nuclear.bam`
samtools view -b -o ../out/${name}.bam -L y.bed $bam
angsd -doFasta 2 \
	-i ../out/${name}.bam \
	-uniqueOnly 1 -remove_bads 1 -minQ 20 -minMapQ 25 \
	-C 50 -ref $REF \
	-only_proper_pairs 0 \
	-doCounts 1 \
	-out ../out/${name}
gzip -d ../out/${name}.fa.gz

#get single-copy region and splice fasta
python spliceFasta.py \
	--bed scy.bed \
	--infasta ../out/${name}.fa \
	--name $name | fold -w60 > ../out/${name}.scy.fa
samtools faidx ../out/${name}.scy.fa
