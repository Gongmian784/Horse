#!/bin/bash
#quality filter for indel using GATK4
gatk VariantFiltration \
	-V ../02.call/out/chr${1}.vcf.gz \
	-filter "QD < 2.0" --filter-name "QD2" \
	-filter "QUAL < 30.0" --filter-name "QUAL30" \
	-filter "FS > 200.0" --filter-name "FS200" \
	-filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
	-O ../out/chr${1}.indel.marked.vcf.gz
