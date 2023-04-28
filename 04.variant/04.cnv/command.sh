#!/bin/bash
for i in `cat select.samplelist` ; do ls ../../02.rescale.trim/merge/nuclear/${i}.nuclear.bam ; done > select.bamlist
for i in `cat select.bamlist` ; do bash 01.Individual.Process.sh $i ; done
bash 02.CNV.Discovery.sh
python PATH-TO-CNVcaller/Genotype.py --cnvfile mergeCNVR --outprefix genotypeCNVR --nproc 24
