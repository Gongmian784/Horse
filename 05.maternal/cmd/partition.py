# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:14:54 2019

@author: Gongmian
"""

import pandas as pd
from collections import defaultdict
import click
import pybedtools
import re


@click.command()
@click.option('--gfffile')
@click.option('--refid')
@click.option('--infasta')
@click.option('--partitionfilter', help='提供仅保留的分区类型，逗号分隔（不能有空格），如CDS,rRNA,tRNA，默认全部保留，同时会去掉fasta中不保留的点', default=None)
@click.option('--outprefix', help='输出总的序列以及每种分区的序列, fasta格式')
@click.option('--outpartition')
def main(gfffile, refid, infasta, partitionfilter, outprefix, outpartition):    
    '''
    对马的线粒体进行分区:分为CDS(codon1,2,3)、rRNA、tRNA、sequence_feature(control)、gap(-)、remainder(不存在于注释中的区域)
    ，如果为其他物种，可自行修改脚本
    partitionfilter参数可从以上集合中过滤得到需要的分区
    '''
    #partition
    catagories = {'sequence_feature', 'rRNA', 'tRNA'} #partition catagories in horse except CDS
    gff = defaultdict(list)
    with open(gfffile, 'r') as fg:
        for line in fg:
            tline = line.strip().split()
            if '#' not in line and len(tline) > 4:
                [name, start, end] = tline[2:5]
                if name == 'CDS':
                    gene = re.findall('gene=\w+', line)[0].split('=')[1]
                    gff[name].append((gene,int(start),int(end)))
                elif name in catagories:
                    gff[name].append((int(start),int(end)))
                    
    partition = defaultdict(list)
    for catagory in catagories:
        for start,end in gff[catagory]:
            for i in range(start,end+1):
                partition[i].append(catagory)
    for gene,start,end in gff['CDS']:
        for i in range(start,end+1):
            partition[i].append(gene)
           
    with open(infasta, 'r') as fi:
        seqdict = {}
        for line in fi:
            if line[0] == '>':
                seqid = line.strip()[1:]
                seqdict[seqid] = []
            else:
                seqdict[seqid] += list(line.strip())
    seqdf = pd.DataFrame(seqdict)
    
    i = 1
    annotation = []
    for base in seqdf[refid]:
        if base == '-':
            annotation.append(['gap'])
        elif i not in partition:
            annotation.append(['remainder'])
            i+=1
        else:
            annotation.append(partition[i])
            i+=1
    annotation = pd.Series(annotation)
    seqdf['annotation'] = annotation
    
    #filter
    if partitionfilter:
        remain = set(partitionfilter.strip().split(','))
        remove = {'CDS', 'gap', 'rRNA', 'remainder', 'sequence_feature', 'tRNA'} - remain
        for k, v in seqdf['annotation'].items():
            for i in v:
                if i in remove:
                    v.remove(i)
        seqdf = seqdf.loc[seqdf['annotation'].map(lambda x:','.join(x)) != '', :]
        
    seqdf.index=range(1, seqdf.shape[0]+1)

    #merge positions
    inbed = ''
    for k, v in seqdf['annotation'].items():
        for i in v:
            if i == 'gap' or i == 'remainder':
                inbed += f'remainder\t{k-1}\t{k}\n'
            else:
                inbed += f'{i}\t{k-1}\t{k}\n'
    bed = pybedtools.BedTool(inbed, from_string=True).sort().merge()

    #output the partition file
    partdict = defaultdict(list)
    for line in str(bed).strip().split('\n'):
        [name, start, end] = line.strip().split()
        if name in {'rRNA', 'remainder', 'sequence_feature', 'tRNA'}:
            partdict[name].append((int(start)+1, int(end)))
        else: #CDS
            print(name)
            for index, i in enumerate(('1stpos', '2ndpos', '3rdpos'), 1):
               partdict[i].append((int(start)+index, int(end)))
    print(partdict)
    
    with open(outpartition, 'w') as fp:
        fp.write('begin assumptions;\n')
        for key in partdict:
            fp.write(f'    charset {key} =')
            if key in {'1stpos', '2ndpos', '3rdpos'}:
                for start, end in partdict[key]:
                    fp.write(f' {start}-{end}\\3')
            else:
                for start, end in partdict[key]:
                    fp.write(f' {start}-{end}')
            fp.write(';\n')
        fp.write('end;\n')
    
    #output the fasta files
    posdict = defaultdict(set)
    for key in partdict:
        if key in {'1stpos', '2ndpos', '3rdpos'}:
            for start, end in partdict[key]:
                for i in range(start, end+1, 3):
                    posdict[key].add(i)
        else:
            for start, end in partdict[key]:
                for i in range(start, end+1):
                    posdict[key].add(i)
    print(posdict)
    
    df = seqdf.copy()
    del df['annotation']
    with open(f'{outprefix}.fa','w') as fo:
        for colindex, col in df.iteritems():
            fo.write(f">{colindex}\n{''.join(col)}\n")  
    
    for key in posdict:
        tmpdf = df[df.index.isin(posdict[key])]
        with open(f'{outprefix}.{key}.fa','w') as fo:
            for colindex, col in tmpdf.iteritems():
                fo.write(f">{colindex}\n{''.join(col)}\n") 

    #check CDS:
    warn = 0
    for start, end in partdict['1stpos']:
        if (end-start+1)%3 != 0:
            warn += 1
            print(f'{start}-{end}: CDS区间不能被3整除！请检查check.csv')
    if warn > 0:
        seqdf.to_csv('check.csv')

if __name__ == '__main__':
    main()
    
