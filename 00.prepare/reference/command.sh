#!/bin/bash
# Preparing the nuclear reference (fna files could be downloaded from NCBI assembly)
sed -f rename.sed GCF_002863925.1_EquCab3.0_genomic.fna > horse.fasta
sed -f rename.sed GCA_002166905.2_LipY764_genomic.fna > LipY764.fasta
cat LipY764.fasta >> horse.fasta
bwa index horse.fasta
samtools faidx horse.fasta
java -jar picard.jar CreateSequenceDictionary R=horse.fasta O=horse.dict

# Preparing the mitochondrial reference
samtools faidx horse.fasta MT > horse_mt.fasta
bwa index horse_mt.fasta
samtools faidx horse_mt.fasta
java -jar ~/bin/picard.jar CreateSequenceDictionary R=horse_mt.fasta O=horse_mt.dict
cd ..

# Make blast database
makeblastdb -dbtype nucl -in horse.fa -parse_seqids -out horse.fa.db

# Make annovar database
gtfToGenePred horse.gtf horse_refGene.txt -genePredExt -allErrors
retrieve_seq_from_fasta.pl horse_refGene.txt --seqfile horse.fasta -format refGene -outfile horse_refGeneMrna.fasta

# Split autosomal genome into blocks
bedtools makewindows -g auto.genome -w 10000000 > auto.10m.bed
awk '{print $1":"$2"-"$3}' auto.10m.bed > auto.10m.region
