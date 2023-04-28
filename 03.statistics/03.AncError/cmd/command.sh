#!/bin/bash
#generate consensus files for the ancestral genome (outgroup)
bash consensus.sh

#estimate the error rates for all individuals
bash angsd.ancerror.sh
