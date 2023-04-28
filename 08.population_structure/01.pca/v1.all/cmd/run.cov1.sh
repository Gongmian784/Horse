#!/bin/bash
source ~/.bashrc
plink --keep cov1.list --geno 0.1 --maf $1 \
	--bfile ../../../../04.variant/01.pseudo-haploid/cmd/chrAuto.tv \
	--horse --make-bed \
	--out ../out/chrAuto.tv.cov1.miss0.1.maf${1}

echo "genotypename: ../out/chrAuto.tv.cov1.miss0.1.maf${1}.bed
snpname: ../out/chrAuto.tv.cov1.miss0.1.maf${1}.bim
indivname: cov1.ind
evecoutname: ../out/chrAuto.tv.cov1.miss0.1.maf${1}.evec
evaloutname: ../out/chrAuto.tv.cov1.miss0.1.maf${1}.eval
outlieroutname: ../out/chrAuto.tv.cov1.miss0.1.maf${1}.log
numthreads: 4
numchrom: 31
numoutlieriter: 0" > smartpca.tv.cov1.miss0.1.maf${1}.par
smartpca -p smartpca.tv.cov1.miss0.1.maf${1}.par
python ../../smartpca_out2tsv.py \
	--evecfile ../out/chrAuto.tv.cov1.miss0.1.maf${1}.evec \
	--evalfile ../out/chrAuto.tv.cov1.miss0.1.maf${1}.eval \
	--groupfile group > ../out/chrAuto.tv.cov1.miss0.1.maf${1}.tsv
group=`head -1 ../out/chrAuto.tv.cov1.miss0.1.maf${1}.tsv | cut -f1`
id=`head -1 ../out/chrAuto.tv.cov1.miss0.1.maf${1}.tsv | cut -f2`
pc1=`head -1 ../out/chrAuto.tv.cov1.miss0.1.maf${1}.tsv | cut -f3`
pc2=`head -1 ../out/chrAuto.tv.cov1.miss0.1.maf${1}.tsv | cut -f4`
python ../../plot_interactive_scatter.py \
	--datafile ../out/chrAuto.tv.cov1.miss0.1.maf${1}.tsv \
	--xcol $pc1 \
	--ycol $pc2 \
	--tags $id \
	--groupby $group \
	--groupcolor colors.json \
	--outprefix v1.all.cov1.miss0.1.maf${1}
