#!/bin/bash
export bam=$1
export name=`basename $1 .nuclear.bam`
export bed=$2
paleomix coverage --regions-file $bed --overwrite-output --target-name $name $bam ../out/${name}.${bed%.bed}.coverage
