#!/bin/bash
# Estimate the SFS of each group
for i in $GROUP1 $GROUP2
# $GROUPX is a group file containing the sample ID, one per line.
do
	mkdir -p ../$i
	for x in `cat ${i}` ; do ls ../../02.rescale.trim/merge/nuclear/${x}.nuclear.bam ; done > ${i}.bamlist
	for j in `cat ../../00.prepare/reference/auto.10m.region`
	do
		bash 01.saf.sh $j $i
	done
done

for i in $GROUP1 $GROUP2
do
	for j in `cat ../../00.prepare/reference/auto.10m.region`
	do
		bash 02.saf2theta.sh $j $i
	done
done

# extimate thetaP of each group in 50kbp windows and 10kbp steps
for i in $GROUP1 $GROUP2
do
	for j in `cat ../../00.prepare/reference/auto.10m.region`
	do
		bash 03.slidetheta.w50k.s10k.sh $j $i
	done
	# merge
	head -1 ../${i}/${j}.w50k.s10k.thetas.pestPG > ../${i}/chrAuto.w50k.s10k.thetas.pestPG
	for j in `cat ../../00.prepare/reference/auto.10m.region`
	do
		sed '1d' ../${i}/${j}.w50k.s10k.thetas.pestPG
	done >> ../${i}/chrAuto.w50k.s10k.thetas.pestPG
done

# extimate FST between two groups in 50kbp windows and 10kbp steps
for j in `cat ../../00.prepare/reference/auto.10m.region`
do
	bash 04.fst.w50k.s10k.sh $j $GROUP1 $GROUP2
done
head -1 ../${GROUP1}_vs_${GROUP2}/${j}.w50k.s10k.fst > ../${GROUP1}_vs_${GROUP2}/chrAuto.w50k.s10k.fst

# merge
for j in `cat ../../00.prepare/reference/auto.10m.region`
do
	sed -e '1d' -e 's/)(/\t/g' -e 's/,/\t/g' -e 's/(\|)//g' ${j}.w50k.s10k.fst | awk '{print $7"\t"$5"\t"$6"\t"$8"\t"$9"\t"$10}' >> ../${GROUP1}_vs_${GROUP2}/chrAuto.w50k.s10k.fst
done

# gene annotation using annovar
annotate_variation.pl --outfile chrAuto.w50k.s10k.select.region --buildver horse chrAuto.w50k.s10k.filter.select.region ../../00.prepare/reference
# chrAuto.w50k.s10k.select.region is a 1-based file without header, formated as "CHR START END 0 0 0"
