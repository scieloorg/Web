export BATCHES_PATH=scielo2lilacs/linux/

export SCILIL_GER_SRCDB=$1
export SCILIL_GER_VALID_LIST=$2
export SCILIL_GER_TITLES=$3
export SCILIL_GER_LIMITDATE=$4
export SCILIL_GER_cipar_file=$5

scielo2lilacs/linux/iso2mst.bat $SCILIL_GER_TITLES $SCILIL_MX scielo2lilacs/fst/titles.fst
scielo2lilacs/linux/iso2mst.bat $SCILIL_GBL_LILTITLE $SCILIL_MX scielo2lilacs/fst/titles.fst
scielo2lilacs/linux/iso2mst.bat $SCILIL_GBL_COLLECTIONS $SCILIL_MX scielo2lilacs/fst/collections.fst
scielo2lilacs/linux/iso2mst.bat $SCILIL_GER_SRCDB $SCILIL_MX scielo2lilacs/fst/src.fst


if [ -f "$SCILIL_GER_TITLES.mst" ]
then
	if [ -f "$SCILIL_GBL_LILTITLE.mst" ]
	then
		if [ -f "$SCILIL_GBL_COLLECTIONS.mst" ]
		then
			if [ -f "$SCILIL_GER_SRCDB.mst" ]
			then
				echo Generating a list from $SCILIL_GER_SRCDB
				$SCILIL_MX $SCILIL_GER_SRCDB lw=9999 count=1 "pft=''" now >  $SCILIL_GER_VALID_LIST
				$SCILIL_MX $SCILIL_GER_SRCDB lw=9999 "pft=if a(v41) and v32<>'ahead' and v32<>'review' then v35,' ',|v|v31,|n|v32,|s|v131,|s|v132,' ',v880*1.17,' ',v65/ fi" now | sort -u > temp/scielo2lilacs_list.txt

				echo Evaluating the list temp/scielo2lilacs_list.txt
				echo Wait ...

				$SCILIL_MX seq=temp/scielo2lilacs_list.txt lw=9999 "pft=if p(v1)  then '$BATCHES_PATH/validateList.bat $SCILIL_GER_VALID_LIST $SCILIL_GER_cipar_file $SCILIL_GER_LIMITDATE ',v1/ fi" now> temp/scielo2lilacs_validateIssue.bat

				chmod 775 temp/scielo2lilacs_validateIssue.bat
				echo Wait
				temp/scielo2lilacs_validateIssue.bat
				echo $SCILIL_GER_VALID_LIST created
			else
				echo Missing $SCILIL_GER_SRCDB
			fi
		else
			echo Missing $SCILIL_GBL_COLLECTIONS
		fi
	else
		echo Missing $SCILIL_GBL_LILTITLE
	fi
else
	echo Missing $SCILIL_GER_TITLES
fi


