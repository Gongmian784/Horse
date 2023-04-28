#!/bin/bash
mkdir ../data ../out

#prepare data
bash plink2treemix.sh

#run
for i in {0..10}
do
    bash treemix.sh $i
done
