#!/usr/bin/env python2.7
import os

os.chdir('../serial')

#cria listas vazias
dellist = []
prlist = []
naheadlist = []
issuelist = []

#trabalha scilista original
fp = open('scilista.lst', 'r')
for row in fp:
    if row.strip().endswith('del'):
        dellist.append(row.strip())
    else:
        if row.strip().endswith('pr'):
            prlist.append(row.strip())
        else:
            if row.strip().endswith('nahead'):
                naheadlist.append(row.strip())
            else:
                issuelist.append(row.strip())
fp.close()

#trabalha scilistaxml
fp = open('scilistaxml.lst', 'r')
for row in fp:
    if row.strip().endswith('del'):
        dellist.append(row.strip())
    else:
        if row.strip().endswith('pr'):
            prlist.append(row.strip())
        else:
            if row.strip().endswith('nahead'):
                naheadlist.append(row.strip())
            else:
                issuelist.append(row.strip())
fp.close()

print dellist
print prlist
print naheadlist
print issuelist

#reconstroi a scilista.lst
os.system('touch newscilista.lst')
os.system('chmod 775 newscilista.lst')
os.system('if [ -e "scilista.ori.lst" ]; then echo "Arquivo scilista.ori.lst ja existe."; else mv scilista.lst scilista.ori.lst; fi')

fp = open('newscilista.lst', 'w')
if dellist:
    for row in dellist:
        fp.write(row + '\n')
if prlist:
    for row in prlist:
        fp.write(row + '\n')
if naheadlist:
    for row in naheadlist:
        fp.write(row + '\n')
if issuelist:
    for row in issuelist:
        fp.write(row + '\n')
fp.close()

os.system('mv newscilista.lst scilista.lst')

exit()
