#!/bin/bash
# prepare data
for i in `cut -f1 $GROUP` ; do ls ../../02.rescale.trim/merge/nuclear/*.nuclear.bam ; done > bamlist
# $GROUP is a file with two columns formated as "ID GROUP", one sample per line.
cut -f2 $GROUP | uniq -c | awk '{print $1}' > size.file
cut -f2 $GROUP | uniq > bam.filelist.group >> bam.filelist.group
ls /home/gongmian/github/Horse/03.statistics/03.AncError/out/*.ancError > error.filelist
for i in `cat bam.filelist.group ` ; do printf "NA\t" ; grep "/${i}.ancError" error.filelist ; done | sed -e 's/\tNA/\nNA/g' -e 's/NA\t\//\//g' > error.list

# run
for i in `cat ../../00.prepare/reference/auto.10m.region` ; do bash angsd.abba2.sh $i ; done

# merge
head -1 ../out/1:1-10000000.abbababa2 > auto.abbababa2
for i in `cat ../../00.prepare/reference/auto.10m.region` ; do cat ../out/${i}.abbababa2 | sed '1d' ; done >> auto.abbababa2

# estAvgError
Rscript estAvgError.R angsdFile=auto out=auto sizeFile=size.file errFile=error.list nameFile=bam.filelist.group
# estAvgError.R is a Rscript in the directory R of angsd
