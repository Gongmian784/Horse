#!/bin/bash
# select samples for lowest and higest depths allowed
python filter_vcf_depths.py \
	--infile ../../04.filterv1/out/chr${1}.snp.vcf.gz \
	--depthslist $DEPTHTXT | \
bcftools view -i 'MAC>1 & F_MISSING<1' -O z -o ../out/chr${1}.vcf.gz
bcftools index ../out/chr${1}.vcf.gz
# $DEPTHTXT: one sample per line, format as: SAMPLEID\tMINDEPTH\tMAXDEPTH.
