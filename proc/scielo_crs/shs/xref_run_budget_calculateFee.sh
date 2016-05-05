. crossref_config.sh

# taxa para artigos recentes
FEE=$1
BUDGETID=$2


if [ -f $MYTEMP/WHATTODO ]
then
	rm $MYTEMP/WHATTODO
fi
$cisis_dir/mx cipar=$MYCIPFILE DB_PRESUPUESTOS btell=0 "bool=$BUDGETID" "pft='budget: ',v2/" now
$cisis_dir/mx cipar=$MYCIPFILE DB_CTRL_BG btell=0 "bool=$BUDGETID" "pft='saldo: ',v2/" now
echo $FEE

$cisis_dir/mx cipar=$MYCIPFILE DB_PRESUPUESTOS btell=0 "bool=$BUDGETID" "pft=if val(v2)>=(val(ref(['DB_CTRL_BG']l(['DB_CTRL_BG']'$BUDGETID'),v2)) + val('$FEE')) then 'doit' else 'dont' fi/" now > $MYTEMP/WHATTODO

