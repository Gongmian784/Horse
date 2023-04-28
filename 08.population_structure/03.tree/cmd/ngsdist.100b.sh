#!/bin/bash
source ~/.bashrc
mkdir ../out
sites=`wc -l ../data/${1}.bim`
inds=`wc -l ../data/${1}.fam`
awk '{print $1}' ../data/${1}.fam > ${1}.label
ngsDist \
	--geno ../data/${1}.beagle.gz \
	--n_boot_rep 100 \
	--probs \
	--boot_block_size 1 \
	--n_ind $inds \
	--n_sites $sites \
	--pairwise_del \
	--seed 666 \
	--n_threads 4 \
	--out ../out/${1}.dist \
	--labels ${1}.label

fastme -T 4 -i ../out/${1}.100b.dist -s -D 101 -o ../out/${1}.100b.nwk
head -n 1 ../out/${1}.100b.nwk >  ../out/${1}.100b.main.nwk
tail -n +2 ../out/${1}.100b.nwk | awk 'NF' > ../out/${1}.100b.bs.nwk
raxml-ng --support --tree ../out/${1}.100b.main.nwk --bs-trees ../out/${1}.100b.bs.nwk --prefix ${1}.100b --threads 4
