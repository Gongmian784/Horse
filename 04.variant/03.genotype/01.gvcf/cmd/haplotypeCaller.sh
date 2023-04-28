#!/bin/bash
export chr=$1
export bam=$2
export name=$3
/stor9000/apps/users/NWSUAF/2012010954/Software/GATK4/gatk-4.1.8.1/gatk \
	--java-options "-Xmx4g" \
	HaplotypeCaller \
	-ERC GVCF \
	-L $chr \
	-R $REF \
	--minimum-mapping-quality 25 --base-quality-score-threshold 20 \
	-I $bam \
	-O ../out/chr${chr}/${name}.g.vcf.gz
# $REF: reference genome
