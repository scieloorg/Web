. crossref_config.sh

CURRENT_PATH=`pwd`

if [ ! -f $scielo_dir/bases-work/doi/doi.status.txt ];
then
	# create doi database in bases-work
	cd $scielo_dir/bases-work/doi

	DOIDB=$scielo_dir/bases-work/doi/doi
	find . -name "*.mst" > $MYTEMP/doi_displayed_list.txt

	$cisis_dir/mx null count=0 create=$DOIDB now -all
	$cisis_dir/mx seq=$MYTEMP/doi_displayed_list.txt lw=9999 "pft=if s(replace(v1,'./','')):'/' then '$cisis_dir/mx ',replace(replace(v1,'.mst',''),'./',''),' append=$DOIDB now -all'/ fi" now > $MYTEMP/doi_displayed_list.sh
	chmod 754 $MYTEMP/doi_displayed_list.sh
	$MYTEMP/doi_displayed_list.sh

	$cisis_dir/mx $DOIDB fst=@$conversor_dir/fst/doi.fst fullinv=$DOIDB

	#copy it to bases
	cp ${DOIDB}.* $scielo_dir/bases/doi

	cd $CURRENT_PATH
fi

