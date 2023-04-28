#!/bin/bash
bcftools view \
	-f "PASS" \
	-m2 -M2 -v snps \
	-O z -o ../out/chr${1}.snp.vcf.gz \
	--threads 4 \
	../out/chr${1}.snp.marked.vcf.gz
bcftools index ../out/chr${1}.snp.vcf.gz
