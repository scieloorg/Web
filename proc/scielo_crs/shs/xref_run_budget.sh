#
# This script is the main if there is a budget, otherwise the main script is the xref_run.sh
# This script accepts as parameters ORDER Descending or Ascending
# generates a list of articles sorted by publication date
# calculates the fee depending of the publication date according to the CrossRef policies
# then call xref_run.sh for each article
#

. crossref_config.sh
chmod 775 *.sh

BUDGETID=$1
ORDER=$2
# SELECTIONTYPE must be ALL or ONLY_NEVER_PROCESSED or ONLY_NEVER_SUBMITTED
SELECTIONTYPE=$3
COUNT=$4


SORTEDLIST=$MYTEMP/list

echo Este procesamiento hara un deposito de XML en CrossRef
echo 
echo Lee con atencion la configuracion que sera presentada a seguir
echo 
echo ENTER para seguir o CTRL+C para interrumpir
read
clear
echo Este procesamiento hara un deposito de XML en CrossRef considerando
echo 
echo BASE ARTIGO en $ARTIGO_DB
echo cisis en $cisis_dir
echo

echo VALOR PARA ARTICULOS DESDE DE     $FIRST_YEAR_OF_RECENT_FEE \$ $RECENT_FEE
echo VALOR PARA ARTICULOS ANTERIORES A $FIRST_YEAR_OF_RECENT_FEE \$ $BACKFILES_FEE
echo PARA EL PAGO SERA USADO EL PRESUPUESTO CUYO ID ES $BUDGETID
echo

if [ "@$BUDGETID" == "@" ]
then
	echo Informe el valor para el primer parametro BUDGETID 
	exit 0
fi
if [ "@$ORDER" == "@Descending" ]
then
	echo ARTICULOS MAS RECIENTES PARA LOS MAS ANTIGUOS
else
	if [ "@$ORDER" == "@Ascending" ]
	then
		echo ARTICULOS MAS ANTIGUOS PARA LOS MAS RECIENTES
	else
		echo Informe el valor para el segundo parametro ORDER Descending o Ascending
	exit 0
	fi
fi
echo 

if [ "@$SELECTIONTYPE" == "@" ]
then
	echo Informe el valor para el tercer parametro SELECTIONTYPE 
	echo Valores ALL or ONLY_NEVER_PROCESSED or ONLY_NEVER_SUBMITTED
	echo ALL para todos
	echo ONLY_NEVER_PROCESSED para los articulos nunca procesados
	echo ONLY_NEVER_SUBMITTED para los articulos nunca sometidos, es decir, nuevos y con errores

	exit 0
else
	if [ "@$SELECTIONTYPE" == "@ALL" ]
	then
		echo Seran procesados TODOS LOS ARTICULOS
	else
		if [ "@$SELECTIONTYPE" == "@ONLY_NEVER_PROCESSED" ]
		then
			echo Seran procesados los articulos jamas procesados
		else
			if [ "@$SELECTIONTYPE" == "@ONLY_NEVER_SUBMITTED" ]
			then
				echo Seran procesados los articulos jamas procesados y los que tenian errores
			fi
		fi
	fi
fi

###################
# PREPARE THE ENVIROMENT
#

$conversor_dir/shs/xref_prepareEnvBudget.sh $BUDGETID

$cisis_dir/mx cipar=$MYCIPFILE DB_PRESUPUESTOS btell=0 "$BUDGETID" "pft='fecha del presupuesto: 'v3/,'valor del presupuesto: $ ',v2/,'valor usado: $ ',ref(['DB_CTRL_BG']l(['DB_CTRL_BG']'$BUDGETID'),f(val(v2),1,2)),/,'valor disponible: $ ',f(val(v2)-val(ref(['DB_CTRL_BG']l(['DB_CTRL_BG']'$BUDGETID'),v2)),1,2)/" now 
echo

$cisis_dir/mx cipar=$MYCIPFILE DB_PRESUPUESTOS btell=0 "$BUDGETID" "pft=if val(v2) < (val('$BACKFILES_FEE')+val(ref(['DB_CTRL_BG']l(['DB_CTRL_BG']'$BUDGETID'),v2)) ) then 'exit 0'/ fi" now >WHATTODO

WHATTODO=`cat WHATTODO`
if [ "$WHATTODO" = "exit 0" ]
then
	echo NO EJECUTADO POR VALOR INSUFICIENTE 
else
	BATCHBGID=`cat temp`
	echo Batch id $BATCHBGID

	echo Estando correcta la configuracion ENTER para seguir
	echo Estando incorrecta CTRL+C para interrumpir
	echo  editar el crossref_config.sh para corregir la configuracion

	read

	if [ -f $SORTEDLIST.txt ]
	then
		mv $SORTEDLIST.txt $MYTEMP/lixo
	fi

	###################
	# GENERATE THE SORTED LIST
	#

	if [ "@$ORDER" == "@Descending" ]
	then
		
		$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB btell=0  "tp=h" "proc='a9001{$FIRST_YEAR_OF_RECENT_FEE{a9002{$RECENT_FEE{a9003{$BACKFILES_FEE{a9005{$BUDGETID{a9055{$SELECTIONTYPE{'" lw=9999 "pft=@$conversor_dir/pft/xref_generateList.pft" now | sort -u -r > $SORTEDLIST.txt
	else
		if [ "@$ORDER" == "@Ascending" ]
		then
			
			$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB btell=0  "tp=h" "proc='a9001{$FIRST_YEAR_OF_RECENT_FEE{a9002{$RECENT_FEE{a9003{$BACKFILES_FEE{a9005{$BUDGETID{a9055{$SELECTIONTYPE{'" lw=9999 "pft=@$conversor_dir/pft/xref_generateList.pft" now | sort -u > $SORTEDLIST.txt
		else
			$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB btell=0  "tp=h" "proc='a9001{$FIRST_YEAR_OF_RECENT_FEE{a9002{$RECENT_FEE{a9003{$BACKFILES_FEE{a9005{$BUDGETID{a9055{$SELECTIONTYPE{'" lw=9999 "pft=@$conversor_dir/pft/xref_generateList.pft" now | sort -u -r > $SORTEDLIST.txt
		fi
	fi


	###################
	# EXECUTE
	#
	if [ -f $SORTEDLIST.txt ]
	then
		if [ "@$COUNT" = "@" ]
		then
			$cisis_dir/mx cipar=$MYCIPFILE "seq=$SORTEDLIST.txt " lw=99999 "pft='$conversor_dir/shs/xref_run_budget_calculateFee.sh ',v1,' ',v2,' ',v3,' $cisis_dir $MYCIPFILE $BUDGETID ',ref(['DB_PRESUPUESTOS']l(['DB_PRESUPUESTOS']'$BUDGETID'),v2),' ',mfn,' $BATCHBGID'/" now > $MYTEMP/xref_run_budget_calculateFee.sh
		else
			$cisis_dir/mx cipar=$MYCIPFILE "seq=$SORTEDLIST.txt " count=$COUNT lw=99999 "pft='$conversor_dir/shs/xref_run_budget_calculateFee.sh ',v1,' ',v2,' ',v3,' $cisis_dir $MYCIPFILE $BUDGETID ',ref(['DB_PRESUPUESTOS']l(['DB_PRESUPUESTOS']'$BUDGETID'),v2),' ',mfn,' $BATCHBGID'/" now > $MYTEMP/xref_run_budget_calculateFee.sh
		fi
		chmod 775 $MYTEMP/xref_run_budget_calculateFee.sh
		$MYTEMP/xref_run_budget_calculateFee.sh
		
		
		
		echo #######################
		echo
		echo   REPORT of BUDGET ID=$BUDGETID 
		echo 
		# $cisis_dir/mx cipar=$MYCIPFILE DB_BATCH_RUN_BUDGET btell=0 "bool=$BUDGETID" lw=9999  "pft=@$conversor_dir/pft/budget_report.pft" now

		if [ ! -d ../output/crossref/report ]
		then
			mkdir -p ../output/crossref/report/
		fi
		$conversor_dir/shs/xref_report.sh $BUDGETID $BATCHBGID> ../output/crossref/report/$BUDGETID_$BATCHBGID.txt
		echo Lea el informe ../output/crossref/report/$BUDGETID_$BATCHBGID.txt
		echo fin

	fi
fi
