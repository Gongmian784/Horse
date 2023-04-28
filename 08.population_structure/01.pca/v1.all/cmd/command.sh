#!/bin/bash
awk '{print $1"\t"$1}' project.ind > project.list
awk '$3=="cov1"{print $1"\t"$1}' project.ind > cov1.list
awk '$3=="cov1"{print }' project.ind > cov1.ind
bash run.cov1.sh 0.1 0.05 ; bash run.project.sh 0.1 0.05
