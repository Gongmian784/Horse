#!/bin/bash
mkdir ../out
#Calculate coverage for autosome, X ,Y and mitochondria
for i in ../../../02.rescale.trim/merge/nuclear/*.nuclear.bam
do
    for j in auto X Y
    do
        bash coverage.nuclear.sh $i ${j}.bed
    done
done

for i in ../../../02.rescale.trim/merge/mitochondria/*.mitochondria.bam
do
    bash coverage.mitochondria.sh $i
done


#Merge results
for i in ../out/*.mito.coverage
do
    grep -v '#' $i | head -2 | tail -1 | cut -f1,14
done > mito.coverage
for i in auto X Y
do
    for j in ../out/*.${i}.coverage
    do
        grep -v '#' $j | head -2 | tail -1 | cut -f1,14
    done > ${i}.coverage
done
