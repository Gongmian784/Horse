#!/bin/bash
#Please cite the doi: 10.1126/science.aao3297
g++  -O3 -std=c++11 -o f3_beagle f3_beagle.cpp

# Prepare data
bash tped2beagle.sh chrAuto.tv.maf0.01

# run
cut -f1 $SAMPLELIST > chrAuto.tv.maf0.01.label
zcat chrAuto.tv.maf0.01.beagle.gz | sed '1d' | ./f3_beagle chrAuto.tv.maf0.01.label $OUTGROUP > chrAuto.tv.maf0.01.f3.txt
