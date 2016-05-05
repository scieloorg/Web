##################################################################
# Run Process
# Parameter 1 optional ISSN or PID of article
##################################################################

echo "[TIME-STAMP] `date '+%Y%m%d %H%M%S'` - [:INI:] $0 $1 $2 $3 $4 $5"
echo ""

. crossref_config.sh

date '+%Y%m%d%H%M' > logDate.txt


ISSN_OR_PID=$1
PROCESS_ONLY_NEW=DO$2

$conversor_dir/shs/xref_prepareEnv.sh
if [ "$#" -eq "0" ]
then
	$conversor_dir/shs/xref_callGenerateAndUploadXML.sh $PROCESS_ONLY_NEW  
else
	$conversor_dir/shs/xref_callGenerateAndUploadXML.sh $PROCESS_ONLY_NEW $ISSN_OR_PID
fi

echo "Copying Log files to output directory"
if [ ! -d ../output/crossref/log ]; then
	mkdir ../output/crossref/log
fi
if [ -f "*.log" ]; then
	echo moving logs
    mv *.log ../output/crossref/log
else
	mv *.log ../output/crossref/log
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

