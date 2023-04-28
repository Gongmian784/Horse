# -*- coding: utf-8 -*-
"""
Created on Thu Jun  4 16:17:06 2020

@author: Gongmian
"""

import click

def stat(infile, outfile):
    with open(outfile, 'w') as fo, open(infile, 'r') as fi:
        for line in fi:
            tline = line.strip().split()
            if set(tline[4:6]) == set('CT') or set(tline[4:6]) == set('GA'):
                fo.write(f'{tline[1]}\t{tline[4]}\t{tline[5]}\tti\n')
            else:
                fo.write(f'{tline[1]}\t{tline[4]}\t{tline[5]}\ttv\n')
            
                
@click.command()
@click.argument('infile')
@click.argument('outfile')
def main(infile, outfile):
    '''
统计plink bim文件中除转换和颠换的点。
    '''
    stat(infile, outfile)
    
if __name__ == '__main__':
    main()
