#####
# Gerador de lista de chamanda para o shell googleSchoolar_geraXML.sh
# Lista de Parametros
#####
#####
# variaveis
. googleSchoolar_config.sh
#####
cd ..
# listar issn's validos	

cisis/mx $database_issue "proc='s'" "pft=@formats/googleSchoolar_genListIssue.pft" now > shs/issue.sh

# Previne inexistencia do diretorio dos resultados
if [ ! -d "output" ]
then
  mkdir -p output/googleSchoolar
fi

rm output/googleSchoolar/*

echo "<HTML>" > output/googleSchoolar/index.htm
echo "<BODY>" >> output/googleSchoolar/index.htm

cisis/mx $database_issue "proc='s'" "pft=@formats/googleSchoolar_genHTML.pft" now >> output/googleSchoolar/index.htm

echo "</BODY>" >> output/googleSchoolar/index.htm
echo "</HTML>" >> output/googleSchoolar/index.htm

chmod 755 shs/issue.sh

shs/issue.sh

rm shs/issue.sh
