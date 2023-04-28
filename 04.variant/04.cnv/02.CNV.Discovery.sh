#!/bin/bash
for i in `cat select.samplelist` ; do ls RD_normalized/${i}_mean_* ; done > normalized.list ; touch exclude.list
bash PATH-TO-CNVcaller/CNV.Discovery.sh -l normalized.list -e exclude.list -f 0.1 -h 3 -r 0.2 -p primaryCNVR -m mergeCNVR
