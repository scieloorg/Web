##################################################################
# Run Process
# 
##################################################################


# generating a shell program that execute a list of commands that call the crossref_generateRequestXML.sh for each type H database records from article SciELO database
. crossref_config.sh

echo "Running crossref_createOutputDirStructure.sh"
./crossref_createOutputDirStructure.sh
echo "Running crossref_generateRequestXML.sh"
./crossref_generateRequestXML.sh

if [ -f crossref_UploadXML.sh ]; then
	echo "Running crossref_UploadXML.sh" # This shell file is generated dinamically by the step before.
	chmod 777 crossref_UploadXML.sh
	echo "#temp file" > toRemove.sh
	./crossref_UploadXML.sh
	rm crossref_UploadXML.sh
fi

if [ -f toRemove.sh ]; then
echo "Running toRemove.sh" # This shell file is generated dinamically by the the step before.
	chmod 777 toRemove.sh
	./toRemove.sh
	rm toRemove.sh
fi

echo "updating report database"
./crossref_UpadateReportDatabase.sh
echo "Copying Log files to output directory"
if [ ! -d ../output/crossref/log ]; then
	mkdir ../output/crossref/log
fi
if [ -f *.log ]; then
	mv *.log ../output/crossref/log
fi
echo "Copying Database to SciELO"
cp ../databases/crossref/* $scielo_dir/bases/doi

echo "all process done!"
