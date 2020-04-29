#!/bin/bash

. conf.sh

echo "GERANDO A LISTA DE ISSN A SEREM BAIXADOS"
mkdir -p ../temp
$cisis_dir/mx $database_dir/title/title btell=0 LOC=$ tell=0 lw=9999 "pft=@../formats/sjr_issns.pft" now > ../temp/temp_issns.txt

echo "BAIXANDO AS IMAGENS E GERANDO XML"
python sjr_proc.py

#---------------------------------------------------------------#
# movendo arquivos para diretorio de bases
#---------------------------------------------------------------#
echo "MOVENDO PARA DIRETORIO htdocs"
mkdir -p $database_dir/../htdocs/scimago
mv ../temp/meuXML.xml $database_dir/../htdocs/scimago/scimago.xml

#---------------------------------------------------------------#
# removendo arquivos temporarios.
#---------------------------------------------------------------#
echo "REMOVENDO ARQUIVOS TEMPORARIOS"
rm -rf ../temp