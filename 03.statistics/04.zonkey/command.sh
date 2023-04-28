#!/bin/bash
#Zonkey pipeline for Species identification. For more details, please refer to https://paleomix.readthedocs.io/en/stable/
paleomix zonkey run database1.tar samples1.nuclear.txt results1_nuclear
paleomix zonkey run database2.tar samples2.nuclear.txt results2_nuclear
# database1.tar refers to the callabine database, while database2.tar refers to the non-callabine database
# samples[12].nuclear.txt is a file containing two columns (one sample per line): sample name and the path of its own bam file 
