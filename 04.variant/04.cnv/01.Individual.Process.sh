#!/bin/bash
export bam=${1}
export name=`basename $i .nuclear.bam`
bash PATH-TO-CNVcaller/Individual.Process.sh -b $bam -h $name -d PATH-TO-CNVcaller/bin/horse/horse.1000.link -s X
