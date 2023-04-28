# -*- coding: utf-8 -*-
"""
Created on Wed Sep 16 22:19:52 2020

@author: gongmian
"""

import click
import pandas as pd


@click.command()
@click.option('--infiles', help='input file list, one per line')
@click.option('--outfile')
def main(infiles, outfile):
    '''
    merge the result of stat_beagle_heterozygosity.py
    '''
    infiles = [x.strip() for x in open(infiles).readlines()]
    df = pd.read_csv(infiles[0], sep='\s+', index_col=0)
    for infile in infiles[1:]:
        df += pd.read_csv(infile, sep='\s+', index_col=0)
    df.index.name='IND'
    df.heterozygosity = df['sum_het'] / df['count_het']
    df.to_csv(outfile, sep='\t', index=True, header=True, float_format='%.6f', compression=None)
        
    
if __name__ == '__main__':
    main()
