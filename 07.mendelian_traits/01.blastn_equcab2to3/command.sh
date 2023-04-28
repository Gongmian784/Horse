#!/bin/bash
#flank200bp of the EquCab2.0 reference genome
awk -F ':' '{gsub(/chr/,"") ; print $1":"$2-200"-"$2+200}' equcab2.pos > equcab2.f200.region
samtools faidx EquCab2.0.fasta --region-file equcab2.f200.region --output equcab2.f200.fa
blastn -task blastn -db ../../00.prepare/reference/horse.fa.db -query equcab2.f200.fa -num_threads 24 -max_hsps 1 -num_alignments 5 -out equ2to3.f200.blast6.out -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore"
#blastn -task blastn -db ../../00.prepare/reference/horse.fa.db -query equcab2.f200.fa -num_threads 24 -max_hsps 5 -num_descriptions 1 -num_alignments 5 -out equ2to3.f200.blast0.out -outfmt 0
sed -e 's/:/\t/g' -e 's/-/\t/g' equ2to3.f200.blast6.out | awk '$1==$4 && $5>=99' | awk '{print $1":"$2+200"\t"$5"\t"$6"\t"$4":"$11+200}' > equ2to3.f200.pos
