#!/bin/bash 
export chr=$1
export group=$2
thetaStat do_stat ../${group}/${chr}.thetas.idx -win 50000 -step 10000 -outnames ../${group}/${chr}.w50k.s10k.thetas
# thetaStat is a software in directory misc of angsd
