###
## Consulta a base de registro l (reg=l) e gera a lista
##
export BATCHES_PATH=scielo2lilacs/linux/

export SCILIL_GNR_SRCDB=$1
export SCILIL_GNR_GENERATED_LIST=$2
export SCILIL_GNR_LIMITDATE=$3
export SCILIL_GNR_cipar_file=$4


# scielo2lilacs/linux/iso2mst.bat $SCILIL_GNR_TITLES $SCILIL_MX scielo2lilacs/fst/titles.fst

if [ -f "$SCILIL_GBL_TITLES.mst" ]
then
	if [ -f "$SCILIL_GBL_LILTITLE.mst" ]
	then
		
			if [ -f "$SCILIL_GNR_SRCDB.mst" ]
			then
				echo Generating a list from $SCILIL_GNR_SRCDB
				$SCILIL_MX cipar=$SCILIL_GNR_cipar_file $SCILIL_GNR_SRCDB "reg=l" lw=9999 "proc='d9065a9065{$SCILIL_GNR_LIMITDATE{'" "pft=@scielo2lilacs/pft/generateList.pft" now | sort -u > $SCILIL_GNR_GENERATED_LIST
				echo $SCILIL_GNR_GENERATED_LIST created
			else
				echo Missing $SCILIL_GNR_SRCDB
			fi
		
	else
		echo Missing $SCILIL_GBL_LILTITLE
	fi
else
	echo Missing $SCILIL_GBL_TITLES
fi

