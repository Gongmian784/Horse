# -*- coding: utf-8 -*-
"""
Created on Thu Nov 21 10:49:53 2019

@author: Gongmian
"""

import click


@click.command()
@click.option('--bed', help='给定顺序的bed文件。fasta中不存在的序列以N填充，默认直接首尾拼接', default=None)
@click.option('--infasta')
@click.option('--name', help='拼接后的新序列的名字')
def main(bed, infasta, name):
    '''
    将fasta中的序列按一定顺序拼接成一条序列
    '''
    with open(infasta, 'r') as fi:
        seqdict = {}
        for line in fi:
            if line[0] == '>':
                seqid = line.strip()[1:]
                seqdict[seqid] = ''
            else:
                seqdict[seqid] += line.strip()
        
        print(f'>{name}')
        if bed:
            with open(bed, 'r') as fn:
                for line in fn:
                    seqname = line.strip().split()[0]
                    start = int(line.strip().split()[1])
                    end = int(line.strip().split()[2])
                    length = end - start
                    if seqname in seqdict:
                        print(seqdict[seqname][start:end], end='')
                    else:
                        print('N'*length, end='')
                print()

        else:
            print(''.join(seqdict.values()))
                
        
if __name__ == '__main__':
    main()
    
