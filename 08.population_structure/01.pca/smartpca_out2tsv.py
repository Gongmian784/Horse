# -*- coding: utf-8 -*-
"""
Created on Thu Mar 28 09:02:09 2019

@author: Gongmian
"""

import pandas as pd
import click

def load_group(groupfile):
    group = {}
    with open(groupfile, 'r') as f:
        idname, groupname = f.readline().strip().split()[0:2]
        for line in f:
            tline = line.strip().split()
            group[tline[0]] = tline[1]
    return group, idname, groupname
    
@click.command()
@click.option('--evecfile')
@click.option('--evalfile')
@click.option('--groupfile')
def main(evecfile, evalfile, groupfile):
    '''
    依据smartpca生成的evec文件和分组的group文件，将个体分组,输出前5个主成分
    group文件格式举例（有header）：
    ID	Group
    Baiyanghe_FB01H_1850	Ancient_Chinese
    Baiyanghe_FB02H_1250	Ancient_Chinese
    Baiyanghe_FB03H_1250	Ancient_Chinese
    '''
    group, idname, groupname = load_group(groupfile)

    df = pd.read_csv(evalfile, sep='\t',header=None)
    exp1 = '{:.2f}'.format(df[0][0]/df[0].sum()*100)
    exp2 = '{:.2f}'.format(df[0][1]/df[0].sum()*100)
    exp3 = '{:.2f}'.format(df[0][2]/df[0].sum()*100)
    print(f'{groupname}\t{idname}\tPC1({exp1}%)\tPC2({exp2}%)\tPC3({exp3}%)\tPC4\tPC5')
    with open(evecfile, 'r') as f:
        for line in f:
            if '#' in line:
                continue
            else:
                tline = line.strip().split()
                print(group[tline[0]] + '\t' + '\t'.join(tline[0:6]))
        
    
    
if __name__ == '__main__':
    main()
    
