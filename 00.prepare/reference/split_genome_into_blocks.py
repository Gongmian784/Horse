# -*- coding: utf-8 -*-
"""
Created on Wed Jun 24 17:00:34 2020

@author: Gongmian
"""

import click



@click.command()
@click.option('--infile', help='genome file, chr\\tsize')
@click.option('--blocksize', help='block size, default 50000000', default=50000000, type=int)
@click.option('--outfile')
def main(infile, blocksize, outfile):
    '''
    split the genome into blocks
    '''
    genome = {}
    with open(infile, 'r') as fi:
        for line in fi:
            tline = line.strip().split()
            genome[tline[0]] = int(tline[1])
    with open(outfile , 'w') as fo:
        for chrom in genome:
            for i in range(1, genome[chrom], blocksize):
                if i + blocksize <= genome[chrom]:
                    fo.write(f'{chrom}:{i}-{i+blocksize-1}\n')
                else:
                    fo.write(f'{chrom}:{i}-{genome[chrom]}\n')
    
    
if __name__ == '__main__':
    main()
    
