# -*- coding: utf-8 -*-
"""
Created on Wed Jun 30 22:27:47 2021

@author: gongmian
"""

import click
import gzip


@click.command()
@click.option('--infile', help='input sorted plink .frq.strat.gz')
@click.option('--outfile', help='output .treemix.gz')
def main(infile, outfile):
    '''
    convert plink --freq 'gz' output format (must be sorted by coordinate) into treemix format
    '''
    with gzip.open(infile, 'rb') as fi, gzip.open(outfile, 'wb') as fo:
        fi.readline()
        nsnp = snp0 = 0
        poplist = []
        genodict = {}
        for line in fi:
            chrom,snp,group,a1,a2,maf,mac,a = line.decode().strip().split()
            if snp0 == 0:
                snp0 = snp
            if snp != snp0:
                # write
                if nsnp == 0:
                    fo.write((' '.join(poplist) + '\n').encode())
                for index, pop in enumerate(poplist):
                    fo.write(','.join(genodict[pop]).encode())
                    if index != len(genodict)-1:
                        fo.write(' '.encode())
                    else:
                        fo.write('\n'.encode())
                genodict = {}
                snp0 = snp
                nsnp += 1
                
            if nsnp == 0:
                poplist.append(group)
            genodict[group] = [mac, str(int(a)-int(mac))]
        
        for index, pop in enumerate(poplist):
            fo.write(','.join(genodict[pop]).encode())
            if index != len(genodict)-1:
                fo.write(' '.encode())
            else:
                fo.write('\n'.encode())
        nsnp += 1

    print(f'num of snp is {nsnp}')
    
if __name__ == '__main__':
    main()

