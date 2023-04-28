#!/bin/bash
mkdir ../out
#Count MaxDepth for autosome, X and Y
#In order to exclude (at least) the 0.5% most extreme sites based on read depth, not including sites with depth 0
for i in ../../../02.rescale.trim/merge/nuclear/*.nuclear.bam
do
    for j in auto X Y
    do
        bash depths.sh $i ${j}.bed
    done
done


#Merge results
for i in auto X Y
do
    for j in ../out/*.${i}.depths
    do
        grep -v '#' $j | head -2 | tail -1 | cut -f1,6
    done > ${i}.depths
done
