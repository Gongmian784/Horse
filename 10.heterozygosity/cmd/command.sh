#!/bin/bash
#run 
for i in `cat ../../00.prepare/reference/auto.10m.region` ; do bash heterozygosity.sh $i ; done

# merge
ls ../out/* > het.filelist
python merge_beagle_heterozygosity.py --infiles het.filelist --outfile chrAuto.het
csvtk join -t -f IND $GROUP chrAuto.het > chrAuto.group.het.txt
# $GROUP is the file about information of each sample with header, one per line, formated as "IND ID Group ..."

# simple box plot
csvtk -t plot box chrAuto.group.het.txt --horiz -g "Group" -f "heterozygosity" --title "Heterozygosity" > boxplot.png

