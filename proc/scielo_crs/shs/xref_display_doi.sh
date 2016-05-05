. crossref_config.sh

CURRENT_PATH=`pwd`

cd $scielo_proc

if [ -f $scielo_dir/bases-work/doi/doi.status.txt ];
then
	rm $scielo_dir/bases-work/doi/doi.status.txt
fi

./doi/scilista/scilista4art.bat $MYTEMP/doi_display_scilista.txt
./doi/create/doi4art.bat $MYTEMP/doi_display_scilista.txt

cd $conversor_dir/shs
./xref_update_single_doidb.sh

echo updated > $scielo_dir/bases-work/doi/doi.status.txt

cd $CURRENT_PATH

