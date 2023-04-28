#!/bin/bash
mkdir ../out
for i in `cat bamlist` ; do bash consensus.sh $i ; done
for i in `cat select.samplelist` ; do cat ../out/${i}.fa ; done > select.fa

#multi-alignment
muscle -in select.fa -out select.aln.fa

#partition
python partition.py \
    --gfffile ${MT.gff} \
    --refid $REFID \
    --infasta select.aln.fa \
    --partitionfilter 1st,2nd,3rd,rRNA,tRNA,sequence_feature \
    --outprefix select.aln.part6 \
    --outpartition select.aln.part6.partition
#python2 seq.file.converter.py -i select.aln.fa -inf FASTA -outf NEXUS > select.aln.nex
#python2 seq.file.converter.py -i select.aln.fa -inf FASTA -outf PHYLIP > select.aln.phy

#ml tree
raxml-ng --select --msa select.aln.part6.fa --model GTR+G --threads 4 --bs-trees 1000

#modelgenerator and beast, xml file is generated by BEAUTi
java -jar modelgenerator.jar select.aln.part6.fa 4
beast -overwrite -threads 8 $XML
