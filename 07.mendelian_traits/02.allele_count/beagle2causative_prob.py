# -*- coding: utf-8 -*-
"""
Created on Thu Jun 11 16:09:49 2020

@author: Gongmian
"""

import click
import numpy as np
import pandas as pd


@click.command()
@click.option('--beaglefile', help='input beagle file')
@click.option('--countfile', help='input beagle file')
@click.option('--majorcausefile',help='sites where major allele is causative allele')
@click.option('--outfile')
def main(beaglefile, countfile, majorcausefile, outfile):
    '''
    输出causative allele的probability，默认minor allele为causative allele，如果不是，要在majorcausefile中列出
    '''
    dfb = pd.read_csv(beaglefile, sep='\t')
    dfc = pd.read_csv(countfile, sep='\t')
    major_cause = [line.strip() for line in open(majorcausefile, 'r')]
    df = pd.DataFrame()
    df['marker'] = dfb['marker'].copy()
    for smid in dfb.columns[3::3]:
        #计算minor allele的概率
        df[smid] = (dfb[f'{smid}.1']/2 + dfb[f'{smid}.2']).map(lambda x:float(('%.6f')%x))
        #missing位点设为na
        miss = dfb[(dfb[smid]==0.333333)&(dfb[f'{smid}.1']==0.333333)&(dfb[f'{smid}.2']==0.333333)].index
        df.loc[miss,smid] = np.nan
        
    for smid in dfc.columns:
        for ind in dfc.index:
            marker = dfb.loc[ind,'marker']
            a1 = dfb.loc[ind,'allele1']
            a2 = dfb.loc[ind,'allele2']
            prob = df.loc[ind,smid]
            if marker in major_cause:
                #个别major allele为causative allele的情况
                df.loc[ind,smid] = 1 - df.loc[ind,smid]
                a1, a2 = a2, a1
            counts = dfc.loc[ind,smid].strip().split(';')
            if pd.isnull(prob):
                continue
            elif int(counts[a1]) == 0 and int(counts[a2]) <= 1:
                #0/1，0/0类型的位点设为na
                df.loc[ind,smid] = np.nan
            elif int(counts[a2]) <= 1:
                #causative allele数量小于等于1的判为non-causative纯合
                df.loc[ind,smid] = 0


    df.to_csv(outfile,sep='\t',index=0,float_format='%.6f', na_rep='NA')
    
if __name__ == '__main__':
    main()
    
