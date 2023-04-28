#!/bin/bash
gatk \
	--java-options "-Xmx4g" \
	GenotypeGVCFs \
	--tmp-dir ../tmp/chr${1} \
	-R $REF \
	-V ../../02.combine/out/chr${1}.g.vcf.gz \
	-O ../out/chr${1}.vcf.gz
