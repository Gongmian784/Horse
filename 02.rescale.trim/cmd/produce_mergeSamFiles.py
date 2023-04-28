# -*- coding: utf-8 -*-
"""
Created on Thu Aug  8 09:28:37 2019

@author: Gongmian
"""

import click
from collections import defaultdict


def sample2parameter(file):
    '''
    {PREFIX: {SAMPLE: [PATH1, PATH2]}}
    '''
    sam2par = {}

    with open(file, 'r') as f:
        for line in f:
            tline = line.strip().split('/')
            path = line.strip()
            prefix = tline[-3]
            sample = tline[-2]
            
            if prefix not in sam2par:
                sam2par[prefix] = defaultdict(list)
                sam2par[prefix][sample].append(path)
            else:
                sam2par[prefix][sample].append(path)
                    
    return sam2par

def produce_cmd(picard, tmpdir, sample, prefix, outdir, pathlist):
    cmd = f"""java -jar -Djava.io.tmpdir={tmpdir} \\
    {picard} MergeSamFiles \\
    SORT_ORDER=coordinate \\
"""
    for path in pathlist:
        cmd += f"""    I={path} \\
"""
    cmd += f"""    O={outdir}/{sample}.{prefix}.bam
    samtools index {outdir}/{sample}.{prefix}.bam
    """
    return cmd

@click.command()
@click.option('--picard', help='picard的路径')
@click.option('--tmpdir', help='java的tmpdir路径')
@click.option('--bamlist', help='输入所有bam文件列表')
@click.option('--outdir', help='输出结果的路径')
def main(picard, tmpdir, bamlist, outdir):
    '''
    批量生成每个个体的picard MergeSamFiles文件，根据输入文件的路径进行判定
    输入文件每行的格式： */${PREFIX}/${SAMPLE}/${LIBRARY}.*.bam
    PREFIX：参考基因组类型（mitochondria或者nuclear）
    SAMPLE：样本ID
    LIBRARY：文库
    REF：参考基因组路径
    '''
    sam2par = sample2parameter(bamlist)
    
    for prefix in sam2par:
        for sample in sam2par[prefix]:
            cmd = produce_cmd(picard, tmpdir, sample, prefix, outdir, sam2par[prefix][sample])
            with open(f'{sample}.{prefix}.merge.sh', 'w') as f:
                f.write(cmd)
                
    
if __name__ == '__main__':
    main()
    
