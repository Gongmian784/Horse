#!/bin/bash
# Data download (https://www.jianshu.com/p/cf0a7b937413)
cat fasp.fastq.list | while read id
do
  ascp -QT -l 300m -P33001 \
  -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh \
  era-fasp@$id .
done

# Data validation
ls *.gz > fastq.list
for i in `cat fastq.list` ; do grep "\b$i\b" md5.all.txt ; done > md5.fastq.txt
md5sum -c md5.fastq.txt > md5.fastq.check
ls *.sra > sra.list
vdb-validate --option-file sra.list > md5.sra.check 2>&1

# Using sratoolkit to dump the sra files into fastq files
for RUN in *.sra ; do fastq-dump --gzip --split-3 ${RUN}.sra ; done
