#!/bin/bash 
if [ ! -x ../Split ]; then mkdir ../Split; fi
export BAM=$1 #realigned bam
export PREFIX=`basename $1 .realigned.bam | cut -d '.' -f2` #nuclear or mitochondria
export SAMPLE=`basename $1 .realigned.bam | cut -d '.' -f1`
if [ ! -x ../Split/${PREFIX} ]; then mkdir ../Split/${PREFIX}; fi
if [ ! -x ../Split/${PREFIX}/${SAMPLE} ]; then mkdir ../Split/${PREFIX}/${SAMPLE}; fi
java -jar picard.jar SplitSamByLibrary \
		I=${BAM} O=../Split/${PREFIX}/${SAMPLE}
