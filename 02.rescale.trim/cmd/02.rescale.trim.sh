#!/bin/bash
export BAM=${1} #bam split by library
export REF=${2}
export FOLD=`dirname $BAM`
export LIB=`basename $BAM .bam`
export BQ=20

# stat and plot
mapDamage -i $BAM -r $REF -n 100000 -Q $BQ --no-stats --merge-reference-sequences -d ${FOLD}/${LIB}.mapDamage
echo 'mapDamage plot done!'

# stat
perl rescaleTrim.pl ${FOLD}/${LIB}.mapDamage/ > ${FOLD}/${LIB}.mapDamage/subst.txt
echo 'subst plot done!'

# flag
cd ${FOLD}/${LIB}.mapDamage/ && Rscript rescale.R $PWD && cd -
echo 'flag done!'

# mapDamage rescale
cut -d ' ' -f 9,11 ${FOLD}/${LIB}.mapDamage/subst.txt.out | while read c1 c2
do
    echo rescale5p $[${c1}-1] rescale3p $[${c2}-1]
    mapDamage -i $BAM -r $REF -Q $BQ --merge-reference-sequences -d ${FOLD}/${LIB}.rescale.mapDamage \
        --rescale --rescale-out ${FOLD}/${LIB}.r.bam --rescale-length-5p $[${c1}-1] --rescale-length-3p $[${c2}-1]
done
echo 'mapDamage rescale done!'

# trim
samtools index ${FOLD}/${LIB}.r.bam
export LEFT=`cat ${FOLD}/${LIB}.mapDamage/subst.txt.out | awk '{i=$1-1; print i}'`
export RIGHT=`cat ${FOLD}/${LIB}.mapDamage/subst.txt.out | awk '{i=$3-1; print i}'`
echo trimleft $LEFT trimright $RIGHT
python trim_bam.py --left $LEFT --right $RIGHT ${FOLD}/${LIB}.r.bam ${FOLD}/${LIB}.r.t.bam
echo 'trim done!'

# SortSam
java -jar picard.jar SortSam \
	I=${FOLD}/${LIB}.r.t.bam O=${FOLD}/${LIB}.r.t.s.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT 
echo 'picard SortSam done!'

# mapDamage check
mapDamage -i ${FOLD}/${LIB}.r.t.s.bam -r $REF -n 100000 -Q 20 --no-stats --merge-reference-sequences -d ${FOLD}/${LIB}.rescale.trim.mapDamage 
echo 'mapDamage check done!'
