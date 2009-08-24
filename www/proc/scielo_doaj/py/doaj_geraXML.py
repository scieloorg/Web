#!/usr/bin/env python
import os
from doaj_config import *

mxString = ['''%s/mx seq=%s/scielo_doaj/databases/iso6932.seq create=%s/scielo_doaj/databases/iso6932 -all now'''%(cisis,proc_path,proc_path),
   '''%s/mx cipar=%s/scielo_doaj/databases/cipar.cip %s "proc=('G%s/scielo_doaj/gizmo/gizmo_xml')" btell=0  tp=h "proc='d32001'" lw=99999 pft=@%s/scielo_doaj/formats/doaj_XML.pft tell=1000 -all now'''%(cisis,proc_path,database_article,proc_path,proc_path)
    ]

saida = open(proc_path+"/scielo_doaj/databases/cipar.cip",'w')
saida.write('Y.*='+database_title+'.*\n')
saida.write('LANG.*='+proc_path+'/scielo_doaj/databases/iso6932.*')
saida.close()

for y in mxString:
   f=os.popen(y)
   for i in f:
      print i,
