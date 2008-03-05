#!/bin/bash

. conf.sh

echo "CRIANDO XML DE SAIDA"

echo "<SCIMAGOLIST>" > meuXML.xml
#---------------------------------------------------------------#
# efetua a busca na base title para todos titulos tipo Current.
#---------------------------------------------------------------#
echo "GERANDO A LISTA DE JOURNALS A SEREM BAIXADOS"
$cisis_dir/mx $database_dir/title/title LOC=$ tell=0 "pft=@../formats/sjr_format.pft" now > downloadTempList.sh

#---------------------------------------------------------------#
# retirando os hifens dos issns listados
#---------------------------------------------------------------#
sed 's/-//g' downloadTempList.sh > downloadTempList2.sh
mv downloadTempList2.sh downloadTempList.sh

#---------------------------------------------------------------#
# alterando a permissao, e executando o shellscript.
#---------------------------------------------------------------#
echo "BAIXANDO OS JOURNALS LISTADOS"
chmod +x downloadTempList.sh
./downloadTempList.sh 
echo "</SCIMAGOLIST>" >> meuXML.xml

#---------------------------------------------------------------#
# removendo arquivos temporarios.
#---------------------------------------------------------------#
echo "REMOVENDO ARQUIVOS TEMPORARIOS"
rm -rf temp.txt
rm -rf journals*
rm -rf downloadTempList.sh

