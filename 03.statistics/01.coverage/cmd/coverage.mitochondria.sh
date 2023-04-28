#!/bin/bash
export bam=$1
export name=`basename $1 .mitochondria.bam`
paleomix coverage --overwrite-output --target-name $name $bam ../out/${name}.mito.coverage
