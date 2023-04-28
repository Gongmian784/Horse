##NOTE: The following pipeline of rescaling and triming DNA is referred to "http://science.sciencemag.org/content/360/6384/111", please cite if used.
#Three steps: split、trim和merge
#1. SplitSamByLibrary
for i in ../../01.paleomix_bam_pipeline/*.realigned.bam ; do bash 01.split.sh $i ; done

#2. rescale and trim
ls ../split/mitochondria/*/*.bam | while read c ; do echo $c $MTREF ; done > 02.mitochondria.parameter
ls ../split/nuclear/*/*.bam | while read c ; do echo $c $REF ; done > 02.nuclear.parameter
#$MTREF and $REF denotes reference of mitochondrial genome and nuclear genome, respectively.
cat 02.mitochondria.parameter | while read c1 c2 ; do bash 02.rescale.trim.sh $c1 $c2 ; done
cat 02.nuclear.parameter | while read c1 c2 ; do bash 02.rescale.trim.sh $c1 $c2 ; done

#check error
grep 'Error\|error\|Exit\|exit' ../split/mitochondria/*/*.log | cut -d ':' -f1 | sed 's/.log//g' | uniq > mitochondria.error.list
grep 'Error\|error\|Exit\|exit' ../split/nuclear/*/*.log | cut -d ':' -f1 | sed 's/.log//g' | uniq > nuclear.error.list

#3. MergeSamFiles
mkdir ../merge ../merge/mitochondria ../merge/nuclear
ls ../split/mitochondria/*/*.r.t.s.bam > 03.mitochondria.bamlist
ls ../split/nuclear/*/*.r.t.s.bam > 03.nuclear.bamlist
python produce_mergeSamFiles.py --picard ${PICARDPATH}/picard.jar --tmpdir $TMPDIR --bamlist 03.mitochondria.bamlist --outdir ../merge/mitochondria
python produce_mergeSamFiles.py --picard ${PICARDPATH}/picard.jar --tmpdir $TMPDIR --bamlist 03.nuclear.bamlist --outdir ../merge/nuclear
#$PICARDPATH: the directory to the picard software. $TMPDIR: the temporary directory of picard.
for i in *.merge.sh ; do bash ${i} ; done
