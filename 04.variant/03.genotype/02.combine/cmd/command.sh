#!/bin/bash
mkdir ../out
# NOTE: The process is very time-comsuming, please split the individuals into groups to speed.
echo "gatk \\
	--java-options \"-Xmx4g -Xms4g\" \\
	CombineGVCFs \\
	--tmp-dir ../tmp/chr1 \\
	-R $REF \\" > combine.sh
# $REF is the reference genome
sed -e 's/^/\t-V /g' -e 's/$/ \\/g' chr1.gvcflist >> combine.sh
# chr1.gvcflist is the file list of chr1, one individual per line.
echo "	-O ../out/chr1.g.vcf.gz" >> combine.sh
sed -i 's/chr1/chr${1}/g' combine.sh

for i in {1..31} X
do
	mkdir -p ../tmp/chr${i}
	bash combine.sh ${i}
done
