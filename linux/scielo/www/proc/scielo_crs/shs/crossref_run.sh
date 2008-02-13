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
	mkdir ../output/crossref/log
fi
if [ -f "*.log" ]; then
        mv *.log ../output/crossref/log
fi
echo "Copying Database to SciELO"
#[nos tempos do SciELO3] cp ../databases/crossref/* $scielo_dir/bases/doi
# Corrente: scielo_crs/shs
# Temporariamente envia tambem para SciELO3, no dia que SciELO.ORG estiver em HM1 tira isso tb!
echo "scp ../databases/crossref/* scielo3:$scielo_dir/bases/doi"
      scp ../databases/crossref/* scielo3:$scielo_dir/bases/doi

echo "scp ../databases/crossref/* scielohm1:$scielo_dir/bases/doi"
      scp ../databases/crossref/* scielohm1:$scielo_dir/bases/doi

# Transferencia FTP deve equivalente:

#echo "Envia resultados para SciELOhm1"
#echo "open scielohm1.bireme.br"               >qdoi.ftp
#echo "user scielosp 03ssp323"                >>qdoi.ftp
#echo "bin"                                   >>qdoi.ftp
#
#echo "Posiciona diretorios"
#echo "cd $scielo_dir/bases/doi"              >>qdoi.ftp
#echo "lcd $conversor_dir/databases/crossref" >>qdoi.ftp
#
#echo "mput *"                                >>qdoi.ftp
#
#echo "bye"                                   >>qdoi.ftp
#ftp -i -v -n < qdoi.ftp >../../outs/log_qdoi_ftp.log

echo "all process done!"

echo ""
echo "[TIME-STAMP] `date '+%Y%m%d %H%M%S'` - [:FIM:] $0 $1 $2 $3 $4 $5"

