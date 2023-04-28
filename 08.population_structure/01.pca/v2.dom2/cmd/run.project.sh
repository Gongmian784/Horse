#!/bin/bash
source ~/.bashrc
cut -f2 ../out/chrAuto.tv.cov1.miss0.1.maf${1}.bim > chrAuto.tv.cov1.miss0.1.maf${1}.sites
plink --keep project.list --extract chrAuto.tv.cov1.miss0.1.maf${1}.sites \
	--bfile ../../../../04.variant/01.pseudo-haploid/cmd/chrAuto.tv \
	--horse --make-bed \
	--out ../out/chrAuto.tv.project.miss0.1.maf${1}

echo "genotypename: ../out/chrAuto.tv.project.miss0.1.maf${1}.bed
snpname: ../out/chrAuto.tv.project.miss0.1.maf${1}.bim
indivname: project.ind
evecoutname: ../out/chrAuto.tv.project.miss0.1.maf${1}.evec
evaloutname: ../out/chrAuto.tv.project.miss0.1.maf${1}.eval
outlieroutname: ../out/chrAuto.tv.project.miss0.1.maf${1}.log
numthreads: 4
numchrom: 31
lsqproject: YES
poplistname: poplist
numoutlieriter: 0" > smartpca.tv.project.miss0.1.maf${1}.par
smartpca -p smartpca.tv.project.miss0.1.maf${1}.par
python ../../smartpca_out2tsv.py \
	--evecfile ../out/chrAuto.tv.project.miss0.1.maf${1}.evec \
	--evalfile ../out/chrAuto.tv.project.miss0.1.maf${1}.eval \
	--groupfile group > ../out/chrAuto.tv.project.miss0.1.maf${1}.tsv
group=`head -1 ../out/chrAuto.tv.project.miss0.1.maf${1}.tsv | cut -f1`
id=`head -1 ../out/chrAuto.tv.project.miss0.1.maf${1}.tsv | cut -f2`
pc1=`head -1 ../out/chrAuto.tv.project.miss0.1.maf${1}.tsv | cut -f3`
pc2=`head -1 ../out/chrAuto.tv.project.miss0.1.maf${1}.tsv | cut -f4`
python ../../plot_interactive_scatter.py \
	--datafile ../out/chrAuto.tv.project.miss0.1.maf${1}.tsv \
	--xcol $pc1 \
	--ycol $pc2 \
	--tags $id \
	--groupby $group \
	--groupcolor colors.json \
	--outprefix v2.dom2.project.miss0.1.maf${1}
