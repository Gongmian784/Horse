# -*- coding: utf-8 -*-
"""
Created on Tue Apr 20 10:59:19 2021

@author: gongmian
"""

import click
import gzip

@click.command()
@click.option('--tped',help='输入的tped格式文件')
@click.option('--tfam',help='输入样品信息文件，至少要包含tfam格式的前两列（FID和IID）', default=None)
@click.option('--biallelic', help='只保留2等位, (flag)', is_flag=True, default=False)
@click.option('--rmtransi', help='去掉所有转换(transition), (flag)', is_flag=True, default=False)
@click.option('--outfmt', help='输出文件格式，tped（无需tfam）还是beagle（gzip压缩，需要tfam）', default='tped')
@click.option('--outprefix',help='输出的文件前缀')
def main(tped, tfam, biallelic, rmtransi, outfmt, outprefix):
    '''
    简单过滤tped格式的文件（多等位，转换位点），并可转换为beagle格式文件。
    如果是ANGSD haplo2Plink产生的文件，需要先将'N'替换成'0'：sed 's/N N/0 0/g'    
    beagle format：
    http://www.popgen.dk/angsd/index.php/Genotype_Likelihoods#Beagle_format
    allele codes as 0=A, 1=C, 2=G, 3=T
    '''
    with open(tped) as fi:
        if outfmt == 'tped':
            with open(f'{outprefix}.tped', 'w') as fo:
                for line in fi:
                    tline = line.strip().split()
                    chrom, marker, gen, pos = tline[0:4]
                    seta = set(tline[4:])
                    #filter
                    if biallelic:
                        if len(seta-{'0'})!=2:
                            continue
                    if rmtransi:
                        if {'G','A'}.issubset(seta) or {'C','T'}.issubset(seta):
                            continue
                    #write
                    fo.write(f'{line}')

        elif outfmt == 'beagle':
            from collections import Counter
            base2majorminor = {'A':'0', 'C':'1', 'G':'2', 'T':'3'}
            with gzip.open(f'{outprefix}.beagle.gz', 'wb') as fo:
                samplelist = [line.strip().split()[1] for line in open(tfam).readlines()]
                trind = []
                for ind in samplelist:
                    trind.extend([ind,ind,ind])
                fo.write(('marker\tallele1\tallele2\t' + '\t'.join(trind) + '\n').encode())

                for line in fi:
                    tline = line.strip().split()
                    chrom, marker, gen, pos = tline[0:4]
                    alleles = tline[4:]
                    seta = set(alleles)
                    #filter
                    if biallelic:
                        if len(seta-{'0'})!=2:
                            continue
                    if rmtransi:
                        if {'G','A'}.issubset(seta) or {'C','T'}.issubset(seta):
                            continue
                    #major, minor
                    counts = Counter(alleles)
                    del counts['0']
                    major = counts.most_common(2)[0][0]
                    minor = counts.most_common(2)[1][0]
                    #write
                    likelihoods = []
                    for i in range(0, len(alleles), 2):
                        if (alleles[i],alleles[i+1]) == (major,major):
                            likelihoods.append('1.000000\t0.000000\t0.000000')
                        elif (alleles[i], alleles[i+1]) == (minor,minor):
                            likelihoods.append('0.000000\t0.000000\t1.000000')
                        elif {alleles[i], alleles[i+1]} == {major,minor}:
                            likelihoods.append('0.000000\t1.000000\t0.000000')
                        else:
                            #多等位以及缺失会被判定为missing
                            likelihoods.append('0.333333\t0.333333\t0.333333')
                    fo.write((f'{marker}\t{base2majorminor[major]}\t{base2majorminor[minor]}\t' + '\t'.join(likelihoods) + '\n').encode())

        else:
            raise Exception(f'{outfmt}:输出文件格式必须为tped或者beagle！')
    
    
if __name__ == '__main__':
    main()

