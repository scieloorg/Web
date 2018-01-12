#!/usr/bin/env python2.7
import os
import shutil

os.chdir('../serial')

#cria listas vazias
dellist = []
prlist = []
naheadlist = []
issuelist = []

#trabalha scilista original
rows = open('scilista.lst', 'r').readlines() + open('scilistaxml.lst', 'r').readlines()
rows = list(set(rows))
for row in rows:
    row = row.strip()
    if len(row) > 0:
        if row.endswith('del'):
            dellist.append(row)
        else:
            if row.endswith('pr'):
                prlist.append(row)
            else:
                if row.endswith('nahead'):
                    naheadlist.append(row)
                else:
                    issuelist.append(row)

#reconstroi a scilista.lst
#os.system('touch newscilista.lst')
#os.system('chmod 775 newscilista.lst')

shutil.copyfile('scilista.lst', 'scilista.ori.lst')

rows = dellist + prlist + naheadlist + issuelist
content = '\n'.join(rows)+'\n'
print(content)
open('scilista.lst', 'w').write(content)

exit()
