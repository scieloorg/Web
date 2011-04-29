#!/usr/bin/env python
import os
import datetime
from doaj_config import *

# READING LAST PROCESS DATE BEFORE UPDATE IT
lastprocessdate = open(proc_path+"/scielo_doaj/databases/lastprocess.txt").readline().replace("\n","")

# CONSTRUCTING CONFIG PROC
if len(doi_prefix) > 0:
    proc_conf = "a1901#"+doi_prefix

proc_conf = proc_conf+"#a1902#"+domain+"#"
proc_conf = '''"proc='%s'"'''%(proc_conf)

mxString = ['''%s/mx seq=%s/scielo_doaj/databases/iso6932.seq create=%s/scielo_doaj/databases/iso6932 -all now'''%(cisis,proc_path,proc_path),
   '''%s/mx %s/scielo_doaj/databases/iso6932 fst=@%s/scielo_doaj/databases/iso6932.fst fullinv=%s/scielo_doaj/databases/iso6932'''%(cisis,proc_path,proc_path,proc_path),
   '''%s/mx cipar=%s/scielo_doaj/databases/cipar.cip %s "proc=('G%s/scielo_doaj/gizmo/gizmo_xml')" %s %s btell=0  tp=h "proc='d32001'" lw=99999 pft=@%s/scielo_doaj/formats/doaj_XML.pft tell=1000 -all now'''%(cisis,proc_path,database_article,proc_path,proc_conf,lastprocessdate,proc_path)
    ]

# REMOVING FILE
os.popen("rm "+proc_path+"/scielo_doaj/databases/lastprocess.txt")

# CREATING FILE WITH NEW NEW PROCESS DATE
lastprocess = open(proc_path+"/scielo_doaj/databases/lastprocess.txt",'w')
lastprocess.write('''"proc='a1900#'''+datetime.date.today().isoformat().replace('-','')+'''#'"''')
lastprocess.close()


saida = open(proc_path+"/scielo_doaj/databases/cipar.cip",'w')
saida.write('Y.*='+database_title+'.*\n')
saida.write('LANG.*='+proc_path+'/scielo_doaj/databases/iso6932.*\n')
saida.write('LASTPROCESS='+lastprocessdate)
saida.close()

for y in mxString:
   f=os.popen(y)
   for i in f:
      print i,
