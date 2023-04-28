#!/bin/bash
#genotype probability
for i in `cat select.samplelist` ; do ls /stor9000/apps/users/NWSUAF/2014010784/01.Horse_Project/paleomix/03.mapDamage/merge/nuclear/${i}.nuclear.bam ; done > select.bamlist
cut -f3 ../01.blastn_equcab2to3/equ2to3.f200.pos > mendelian.region
bash angsd.sh

#rename
awk 'BEGIN{ind=0;print "{"} {print "s/\\bInd"ind"\\b/"$1"/g"; ind++}END{print "}"}' select.samplelist > rename_beagle.sed
zcat mendelian.beagle.gz | sed -f rename_beagle.sed > mendelian.rename.beagle
awk 'BEGIN{ind=0;print "{"} {print "s/ind"ind"_/"$1"_/g"; ind++}END{print "}"}' select.samplelist > rename_counts.sed
zcat mendelian.counts.gz | sed -f rename_counts.sed | awk '{for (i=1;i<=NF;i++){if (i%4!=0){printf $i";"}else{printf $i"\t"}};printf "\n"}' | perl -pe 's/_A;(.*?)_T\t/\t/g' | sed 's/\t$//g' > mendelian.rename.counts

# output probablity of causative alleles
python beagle2causative_prob.py \
       --beaglefile mendelian.rename.beagle \
       --countfile mendelian.rename.counts \
       --majorcausefile majorcause.list \
       --outfile mendelian.rename.prob
