#!/bin/bash
#concat autosomal chromosomes, bcftools v1.10 is much more faster than previous versions.
for i in {1..31} ; do ls ../out/chr${i}.vcf.gz ; done > allauto.list
bcftools concat \
	-f allauto.list \
	-O z -o chrAuto.vcf.gz \
	--threads 24
bcftools index chrAuto.vcf.gz --threads 24

# vcf to plink
plink --vcf chrAuto.vcf.gz --horse --double-id --make-bed --out chrAuto --threads 24
awk '{print $1"\t"$1"_"$4"\t"$3"\t"$4"\t"$5"\t"$6}' chrAuto.bim > chrAuto.tmp.bim ; mv chrAuto.tmp.bim chrAuto.bim

# remove transitions
bcftools view \
	-e '(REF="C" & ALT="T") | (REF="T" & ALT="C") | (REF="G" & ALT="A") | (REF="A" & ALT="G")' \
	-O z -o chrAuto.tv.vcf.gz \
	chrAuto.vcf.gz \
	--threads 24
bcftools index chrAuto.tv.vcf.gz --threads 24
plink --vcf chrAuto.tv.vcf.gz --horse --double-id --make-bed --out chrAuto.tv --threads 24
awk '{print $1"\t"$1"_"$4"\t"$3"\t"$4"\t"$5"\t"$6}' chrAuto.tv.bim > chrAuto.tv.tmp.bim ; mv chrAuto.tv.tmp.bim chrAuto.tv.bim
