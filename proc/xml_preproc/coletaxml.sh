#!/bin/bash
. xml_preproc.ini

echo Processamento $XMLPREPROC_COLLECTION_NAME
echo Ordenando scilistas
#remove duplicidades das scilistas
#scilistaxml.lst
sort -u ../serial/scilistaxml.lst > ../serial/scilistaxml_ord
cat ../serial/scilistaxml_ord > ../serial/scilistaxml.lst

#scilista.lst
sort -u ../serial/scilista.lst > ../serial/scilista_ord
cat ../serial/scilista_ord > ../serial/scilista.lst

echo Executando getbasesxml4proc.py para coleta das Bases XML
echo

./getbasesxml4proc.py

echo Fazendo a juncao das listas 'scilistaxml.lst' e 'scilista.lst'
echo
./joinlist.py

echo ------------------------
echo Proximo passo:
echo
echo Executar processar.sh
