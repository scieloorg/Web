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

if [ -f $MYTEMP/WHATTODO ]
then
	rm $MYTEMP/WHATTODO
fi

echo VERIFICA BUDGET
$MYCISISDIR/mx cipar=$MYCIPFILE null count=1 "pft='saldo:  ',ref(['DB_BG']l(['DB_BG']'$BUDGETID'),v4)/,'budget: ',f(val('$MYBUDGET'),1,2)/,'saldo + taxa: ',f( val(ref(['DB_BG']l(['DB_BG']'$BUDGETID'),v4)) + val('$FEE'),1,2)/" now 
$MYCISISDIR/mx cipar=$MYCIPFILE null count=1 "pft=if val('$MYBUDGET')>=(val(ref(['DB_BG']l(['DB_BG']'$BUDGETID'),v4)) + val('$FEE')) then 'doit' else 'dont' fi/" now
#read

$MYCISISDIR/mx cipar=$MYCIPFILE null count=1 "pft=if val('$MYBUDGET')>=(val(ref(['DB_BG']l(['DB_BG']'$BUDGETID'),v4)) + val('$FEE')) then 'doit' else 'dont' fi" now > $MYTEMP/WHATTODO

WHATTODO=`cat $MYTEMP/WHATTODO`


if [ "$WHATTODO" == "doit" ]
then
	$conversor_dir/shs/xref_run.sh $PID $PRIOR

	$cisis_dir/mx $XREF_DOI_REPORT btell=0 "bool=hr=$PID" "pft=if p(v30) then ,'done'/, fi" now > $MYTEMP/WHATTODO
	WHATTODO=`cat $MYTEMP/WHATTODO`

	if [ "$WHATTODO" == "done" ]
	then
		$MYCISISDIR/mx cipar=$MYCIPFILE DB_BILL btell=0 "bool=$PID" count=1 "proc='d4a4{requested{a2{$FEE{a3{',date,'{a1{$BUDGETID{a121{$PRIOR{'" copy=DB_BILL now -all
		$cisis_dir/mx $DB_BILL fst=@$conversor_dir/fst/bill.fst fullinv=$DB_BILL now -all

		echo Novo saldo
		$MYCISISDIR/mx cipar=$MYCIPFILE DB_BG btell=0 "bool=$BUDGETID" "pft=f(val(v4)+val('$FEE'),1,2)/" now
		#read
		$MYCISISDIR/mx cipar=$MYCIPFILE DB_BG btell=0 "bool=$BUDGETID" "proc='d121d4a4{',f(val(v4)+val('$FEE'),1,2),'{a121{$PRIOR{'" copy=DB_BG now -all
	fi
else
	$MYCISISDIR/mx cipar=$MYCIPFILE DB_BILL btell=0 "bool=$PID" count=1 "proc='d121d4a4{dont{a2{$FEE{a3{',date,'{a1{$BUDGETID{a121{$PRIOR{'" copy=DB_BILL now -all	
	$cisis_dir/mx $DB_BILL fst=@$conversor_dir/fst/bill.fst fullinv=$DB_BILL now -all

	$MYCISISDIR/mx cipar=$MYCIPFILE DB_BG btell=0 "bool=$BUDGETID" "proc='d122d10a122{$PRIOR{a10{',f(val(v10)+val('$FEE'),1,2),'{'" copy=DB_BG now -all

fi




