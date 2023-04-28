# -*- coding: utf-8 -*-
"""
Created on Wed Dec  2 16:39:04 2020

@author: gongmian
"""

import click
from pysam import VariantFile


@click.command()
@click.option('--infile')
@click.option('--outfile', default='-', help='out vcf/bcf, default=stdout')
@click.option('--depthslist', help='individual\\tmindepth\\tmaxdepth')
def main(infile, outfile, depthslist):
    '''
    mask genotypes in vcf file based on depths individually according to the given file
    '''
    depthsdict = {l.strip().split()[0] : (int(l.strip().split()[1]), int(l.strip().split()[2])) for l in open(depthslist)}
    invcf = VariantFile(infile, "r")
    outvcf = VariantFile(outfile, 'w', header=invcf.header)
    for rec in invcf.fetch():
        for sample in rec.samples:
            if rec.samples[sample]['DP'] and ((rec.samples[sample]['DP'] < depthsdict[sample][0]) or (rec.samples[sample]['DP'] > depthsdict[sample][1])):
                rec.samples[sample]['GT'] = (None, None)
                rec.samples[sample]['PGT'] = '.'
                rec.samples[sample]['PID'] = '.'
        outvcf.write(rec)
    invcf.close()
    outvcf.close()
                
    
    
if __name__ == '__main__':
    main()

