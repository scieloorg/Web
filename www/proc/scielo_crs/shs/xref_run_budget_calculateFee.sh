. crossref_config.sh

# taxa para artigos recentes
PUBDATE=$1
PID=$2
FEE=$3

MYCISISDIR=$4
MYCIPFILE=$5

BUDGETID=$6

MYBUDGET=$7
PRIOR=$8
BATCHBGID=$9

if [ -f $MYTEMP/WHATTODO ]
then
	rm $MYTEMP/WHATTODO
fi

# echo VERIFICA BUDGET
# $MYCISISDIR/mx cipar=$MYCIPFILE null count=1 "pft='saldo:  ',ref(['DB_CTRL_BG']l(['DB_CTRL_BG']'$BUDGETID'),v2)/,'budget: ',f(val('$MYBUDGET'),1,2)/,'saldo + taxa: ',f( val(ref(['DB_CTRL_BG']l(['DB_CTRL_BG']'$BUDGETID'),v2)) + val('$FEE'),1,2)/" now 
#read

$MYCISISDIR/mx cipar=$MYCIPFILE null count=1 "pft=if val('$MYBUDGET')>=(val(ref(['DB_CTRL_BG']l(['DB_CTRL_BG']'$BUDGETID'),v2)) + val('$FEE')) then 'doit' else 'dont' fi/" now > $MYTEMP/WHATTODO
WHATTODO=`cat $MYTEMP/WHATTODO`

#echo $WHATTODO

if [ "$WHATTODO" == "doit" ]
then
	$conversor_dir/shs/xref_run.sh $PID

	$cisis_dir/mx $XREF_DOI_REPORT btell=0 "bool=hr=$PID" "pft=if p(v30) then ,'done'/, fi" now > $MYTEMP/WHATTODO
	WHATTODO=`cat $MYTEMP/WHATTODO`

	if [ "$WHATTODO" == "done" ]
	then
		$MYCISISDIR/mx cipar=$MYCIPFILE DB_BILL btell=0 "bool=$PID" count=1 "proc='d4d100d121a4{requested{a2{$FEE{a3{',date,'{a1{$BUDGETID{a121{$PRIOR{a100{$BATCHBGID{'" copy=DB_BILL now -all
		$cisis_dir/mx $DB_BILL fst=@$conversor_dir/fst/bill.fst fullinv=$DB_BILL now -all

		#echo Novo saldo
		#$MYCISISDIR/mx cipar=$MYCIPFILE DB_CTRL_BG btell=0 "bool=$BUDGETID" "pft=f(val(v2)+val('$FEE'),1,2)/" now
		#read
		$MYCISISDIR/mx cipar=$MYCIPFILE DB_CTRL_BG btell=0 "bool=$BUDGETID" "proc='d2d90a2{',f(val(v2)+val('$FEE'),1,2),'{a90{',date,'{'" copy=DB_CTRL_BG now -all

		$MYCISISDIR/mx cipar=$MYCIPFILE DB_BATCH_RUN_BUDGET btell=0 "bool=BATCHBG=$BATCHBGID" "proc='d2d90d121a121{$PRIOR{a2{',f(val(v2)+val('$FEE'),1,2),'{a90{',date,'{'" copy=DB_BATCH_RUN_BUDGET now -all
	fi
else
	$MYCISISDIR/mx cipar=$MYCIPFILE DB_BILL btell=0 "bool=$PID" count=1 "proc='d4d100d121a4{dont{a2{$FEE{a3{',date,'{a1{$BUDGETID{a121{$PRIOR{a100{$BATCHBGID{'" copy=DB_BILL now -all	
	$cisis_dir/mx $DB_BILL fst=@$conversor_dir/fst/bill.fst fullinv=$DB_BILL now -all

	$MYCISISDIR/mx cipar=$MYCIPFILE DB_BATCH_RUN_BUDGET btell=0 "bool=BATCHBG=$BATCHBGID" "proc='d90d122d10a122{$PRIOR{a10{',f(val(v10)+val('$FEE'),1,2),'{a90{',date,'{'" copy=DB_BATCH_RUN_BUDGET now -all

fi




