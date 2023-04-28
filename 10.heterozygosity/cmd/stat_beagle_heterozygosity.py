# -*- coding: utf-8 -*-
"""
Created on Fri May 15 10:38:38 2020

@author: Gongmian
"""

import click
import pandas as pd
import gzip


@click.command()
@click.option('--beaglefile', help='压缩的beagle文件')
@click.option('--cutoff', help='仅将het大于cutoff的位点视为杂合。默认0', type=float, default=0)
@click.option('--rmtransi', help='去掉所有转换(transition), (flag)', is_flag=True, default=False)
@click.option('--chunksize', help='一次处理XX行，默认100000', default=100000, type=int)
@click.option('--outfile', help='未压缩的输出文件')
def main(beaglefile, cutoff, rmtransi, chunksize, outfile):
    '''
    统计beagle文件中个体的杂合比例
    '''
    chunker = pd.read_csv(beaglefile, sep='\s+', chunksize=chunksize)
    sumhet = counthet = None
    for chunk in chunker:
        major = chunk.iloc[:,3::3]
        het = chunk.iloc[:,4::3]
        minor = chunk.iloc[:,5::3]
        het.columns = major.columns
        minor.columns = major.columns
        if not (isinstance(sumhet, pd.Series) and isinstance(counthet, pd.Series)):
            zero = pd.Series(0, index=major.columns.copy(), name='ind')
            sumhet = zero.copy()
            counthet = zero.copy()
        df = pd.DataFrame({'major':major.stack(),'het':het.stack(),'minor':minor.stack(),'minor':minor.stack()})
        df.index.names=['site','ind']
        df = df.reset_index()

        cols = ['major', 'het', 'minor']
        #mask missing sites
        sumdf = df[df[cols].max(axis=1) - df[cols].min(axis=1) != 0]
        
        if cutoff:
            sumdf.loc[sumdf['het'] < cutoff, 'het'] = 0
            
        if rmtransi:
            tv = set(chunk.loc[(chunk['allele1']-chunk['allele2']).abs()!=2, :].index)
            sumdf['type'] = sumdf['site'].map(lambda x: 'tv' if x in tv else 'ts')
            sumhet += (sumdf[sumdf['type']=='tv']['het'].groupby(sumdf['ind']).sum() + zero).fillna(0)
        else:
            sumhet += (sumdf['het'].groupby(sumdf['ind']).sum() + zero).fillna(0)
        counthet += (sumdf['het'].groupby(sumdf['ind']).count() + zero).fillna(0)
        
    counthet = counthet.astype(int)
    heterozygosity = sumhet / counthet
    odf = pd.DataFrame({'heterozygosity':heterozygosity,'sum_het':sumhet,'count_het':counthet})
    odf.to_csv(outfile, sep='\t', index=True, header=True, float_format='%.6f', compression=None)


if __name__ == '__main__':
    main()
    
