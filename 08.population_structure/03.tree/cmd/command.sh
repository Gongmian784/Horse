#!/bin/bash
# prepare data
bash tped2beagle.sh chrAuto.tv.maf0.01

# run
bash ngsdist.100b.sh chrAuto.tv.maf0.01
