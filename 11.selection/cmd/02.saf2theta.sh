#!/bin/bash 
export chr=$1
export group=$2
realSFS ../${group}/${chr}.saf.idx -P 8 > ../${group}/${chr}.sfs
realSFS saf2theta ../${group}/${chr}.saf.idx -P 8 -sfs ../${group}/${chr}.sfs -outname ../${group}/${chr}
# realSFS is a software in directory misc of angsd
