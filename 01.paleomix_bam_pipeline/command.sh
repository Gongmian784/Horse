#!/bin/bash
# Prepare data, reference and log directories
ln -s ../00.prepare/data
ln -s ../00.prepare/reference
mkdir log
# Prepare yaml files for paleomix
python produce_yaml_for_paleomix.py --listfile $LISTFILE --yamlfile makefile_edit.yaml
#The format of $LISTFILE could be found in the help information in produce_yaml_for_paleomix.py;
#File makefile_edit.yaml could be manually modified as required.

# Run paleomix for each individual
for i in `ls *.yaml | grep -v 'makefile_edit.yaml'` ; do paleomix bam_pipeline run ${i} --jre-option=-Xmx20g --max-threads=24 ; done

# Remove procedure files after the jobs are all successfully completed
#rm */reads/*/*/*/*.gz */*/*/*/*/*.sai */*/*/*/*/*.bam */*/*/*.bam */*/*/*.bai
#rm data/*/*.gz ; rm data/*/*.sra ; done
