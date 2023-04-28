# -*- coding: utf-8 -*-
"""
Created on Wed May  8 16:49:30 2019

@author: Gongmian
"""

import click
import numpy as np
import pandas as pd

def load_fasta(infasta):
    seqdict = {}
    with open(infasta, 'r') as f:
        seq_id = f.readline().strip().split()[0][1:]
        tmp_seq = []
        for line in f:
            if line[0] != '>':
                tmp_seq.append(line.strip().upper())
            else:
                seqdict[seq_id] = list(''.join(tmp_seq))
                seq_id = line.strip().split()[0][1:]
                tmp_seq = []
        seqdict[seq_id] = list(''.join(tmp_seq))
    return seqdict


def filters(df, keep, extract, missind, misssite, variant, biallelic, singleton):
    if keep:  #personally sample filter
        indlist = [x.strip().split()[0] for x in open(keep).readlines()]
        df = df.loc[:, df.columns.isin(indlist)]
    
    if extract:  #personally site filter
        with open(extract, 'r') as fs:
            sitelist = [int(line.strip()) for line in fs.readlines()]
        df = df.loc[df.index.isin(sitelist), :]
        
    if missind:    #missing ind filter
        mi = (df == 'N').sum()/df.shape[0]
        df = df.loc[:, mi<missind]
    
    if misssite:    #missing site filter
        ms = (df == 'N').sum(axis=1)/df.shape[1]
        df = df.loc[ms<misssite, :]
        
    if variant or biallelic or singleton:
        allele_count = pd.DataFrame()
        for base in ('A','C','G','T'):
            allele_count[base] = (df == base).sum(axis=1)
    
        if variant:    #non-variant filter
            df = df.loc[(allele_count == 0).sum(axis=1)<3, :]
        
        if biallelic:    #triallelic filter
            df = df.loc[(allele_count == 0).sum(axis=1)==2, :]
            
        if singleton:    #singleton filter
            s = ((allele_count == 1).sum(axis=1) == 1) & ((allele_count == 0).sum(axis=1)>=2)
            df = df.loc[~s, :]
    return df
    

@click.command()
@click.option('--infasta')
@click.option('--keep', help='要保留的个体的列表文件（可选）', default=None)
@click.option('--extract', help='保留特定位置碱基的位点，一行一个位点,从0开始（可选）', default=None)
@click.option('--missind', type=float, help='过滤缺失位点比例大于等于该阈值的个体，范围[0,1]（可选）', default=None)
@click.option('--misssite', type=float, help='过滤缺失个体比例大于等于该阈值的位点，范围[0,1]（可选）', default=None)
@click.option('--variant', help='只保留变异的位点（可选）', is_flag=True, default=None)
@click.option('--biallelic', help='只保留二等位变异的位点（可选）', is_flag=True, default=False)
@click.option('--singleton', help='过滤单个个体特异的位点（可选）', is_flag=True, default=False)
def main(infasta, keep, extract, missind, misssite, variant, biallelic, singleton):
    '''
    过滤对齐的fasta文件。
    '''
    seqdict = load_fasta(infasta)
    df = pd.DataFrame(seqdict, dtype="category")
    df = filters(df, keep, extract, missind, misssite, variant, biallelic, singleton)
    for col in df.columns:
        print(f'>{col}')
        print(''.join(df[f'{col}']))
    
if __name__ == '__main__':
    main()
    
