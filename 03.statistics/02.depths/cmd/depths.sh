#!/bin/bash
export bam=$1
export name=`basename $i .nuclear.bam`
export bed=$2
paleomix depths --regions-file $bed --overwrite-output $bam --target-name $name ../out/${name}.${bed%.bed}.depths
