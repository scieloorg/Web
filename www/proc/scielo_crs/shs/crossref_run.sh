##################################################################
# Run Process
# 
##################################################################

echo "[TIME-STAMP] `date '+%Y%m%d %H%M%S'` - [:INI:] $0 $1 $2 $3 $4 $5"
echo ""

# generating a shell program that execute a list of commands that call the crossref_generateRequestXML.sh for each type H database records from article SciELO database
. crossref_config.sh

date '+%Y%m%d%H%M' > logDate.txt

echo "Running crossref_createOutputDirStructure.sh"
rm crossref_UploadXML.sh # removendo arquivo de processamento anterior 
if [ "$#" -eq "0" ]
then
	echo "Toda a colecao SciELO"
	./crossref_createOutputDirStructure.sh
else
	echo "Somente para o ISSN: $1"
	./crossref_createOutputDirStructure_parm.sh $1
fi

## exit 0

echo "Running crossref_generateRequestXML.sh"
./crossref_generateRequestXML.sh

if [ -f crossref_UploadXML.sh ]; then
	echo "Running crossref_UploadXML.sh" # This shell file is generated dinamically by the step before.
	chmod 777 crossref_UploadXML.sh
	echo "#temp file" > toRemove.sh
	./crossref_UploadXML.sh
	#rm crossref_UploadXML.sh
fi

if [ -f toRemove.sh ]; then
echo "Running toRemove.sh" # This shell file is generated dinamically by the the step before.
	chmod 777 toRemove.sh
	./toRemove.sh
	#rm toRemove.sh
fi

echo "updating report database"
./crossref_UpadateReportDatabase.sh
echo "Copying Log files to output directory"
if [ ! -d ../output/crossref/log ]; then
	mkdir -p ../output/crossref/log
fi
#if [ -f "*.log" ]; then
if [ `ls *.log |wc -l` -gt 0 ]; then
	echo copying log
        mv *.log ../output/crossref/log/
else
	echo Cannot copy log
fi
echo "Copying Database to SciELO"
#cp ../databases/crossref/* $scielo_dir/bases/doi
# Corrente: scielo_crs/shs

# Copiar para servidor de TESTE
if  [ $scieloteste ]; then
echo "scp ../databases/crossref/* $scieloteste:$scielo_dir/bases/doi"
      scp ../databases/crossref/* $scieloteste:$scielo_dir/bases/doi
fi

#Copiar para servidor de Homologação
if  [ $scielohomol ]; then
echo "scp ../databases/crossref/* $scielohomol:$scielo_dir/bases/doi"
      scp ../databases/crossref/* $scielohomol:$scielo_dir/bases/doi
fi

#Copiar para servidor de Produção
if  [ $scieloprodu ]; then
echo "scp ../databases/crossref/* $scieloprodu:$scielo_dir/bases/doi"
      scp ../databases/crossref/* $scieloprodu:$scielo_dir/bases/doi
fi
echo "all process done!"

echo ""
echo "[TIME-STAMP] `date '+%Y%m%d %H%M%S'` - [:FIM:] $0 $1 $2 $3 $4 $5"

