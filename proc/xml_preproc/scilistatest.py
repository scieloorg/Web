#!/usr/bin/env python2.7
# coding: utf-8
import os

#Show directory local
print 'dir local: %s\n' % os.getcwd()

#Create error file
os.system('rm scilista-erros.txt')
fbug = open('scilista-erros.txt', 'w')

#Check if exists scilistaxml.lst
if os.path.exists("../serial/scilistaxml.lst"):
    print 'Content of ../serial/scilistaxml.lst'
    os.system('cat ../serial/scilistaxml.lst')
else:
    print "Error: scilistaxml.lst not exists in ../serial "
    fbug.write('Erro: scilistaxml.lst nao existe em ../serial\n')
    exit("check ../serial/scilistaxml.lst")

print '----------------------------------------------\n'

#Builds a list from scilistxml.lst
lst = []
f = open('../serial/scilistaxml.lst', 'r')
for row in f:
    lst.append(row.split())
f.close()

#Test issues in scilistaxml.lst
n = 0
for issue in lst:
    n += 1
    linha = ' '.join(issue)
    print linha
    if len(issue) == 0:
        print('Error: Linha {}: remover linha vazia\n'.format(n))
        fbug.write('Error: Linha {}: remover linha vazia\n'.format(n))
        continue
    elif len(issue) not in [2, 3]:
        print('Error: Linha {}: corrigir {} \n'.format(n, linha))
        fbug.write('Error: Linha {}: corrigir {} \n'.format(n, linha))
        continue
    print('Executar')
    try:
        acron = issue[0]
        acron = issue[1]
        if os.path.exists('/bases/xml.000/serial/' + issue[0] + '/' + issue[1]):
            print 'Issue OK\n'
        else:
            print      '%s %s \t%s\n' % (issue[0],issue[1],'fasciculo nao localizado - verificar')
            fbug.write('%s %s \t%s\n' % (issue[0],issue[1],'fasciculo nao localizado - verificar'))
    except IndexError:
        print       '%s \t%s\n' % (issue[0], 'fasciculo ilegivel - corrigir')
        fbug.write('%s \t%s\n' % (issue[0], 'fasciculo ilegivel - corrigir'))
        continue

fbug.close()
