#!/bin/bash
export chr=$1
export group1=$2
export group2=$3
#calculate the 2dsfs prior
mkdir ../${group1}_vs_${group2}
realSFS -P 8 -r $chr \
	../${group1}/${chr}.saf.idx ../${group2}/${chr}.saf.idx > ../${group1}_vs_${group2}/${chr}.ml
#prepare the fst for easy window analysis etc
realSFS fst index -P 8 -r $chr \
	../${group1}/${chr}.saf.idx ../${group2}/${chr}.saf.idx \
	-sfs ../${group1}_vs_${group2}/${chr}.ml -fstout ../${group1}_vs_${group2}/${chr}
# estimate fst in 50kbp windows and 10kbp steps
realSFS fst stats2 ../${group1}_vs_${group2}/${chr}.fst.idx -win 50000 -step 10000 -type 2 > ../${group1}_vs_${group2}/${chr}.w50k.s10k.fst
