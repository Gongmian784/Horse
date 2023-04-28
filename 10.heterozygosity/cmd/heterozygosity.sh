#!/bin/bash
python stat_beagle_heterozygosity.py \
	--beaglefile ../../04.variant/02.posterior_probability/out/chr${1}.beagle.gprobs.gz \
	--rmtransi \
	--chunksize 10000 \
	--outfile ../out/chr${1}.het
