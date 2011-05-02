. crossref_config.sh

. $conversor_dir/shs/xref_prepareEnv.sh

d=`dirname $DB_CTRL_BG.mst`
if [ ! -d $d ]
then
	mkdir -p $d
fi

BUDGETID=$1
if [ -f $DB_BILL.mst ]
then
	$cisis_dir/mx null count=0 create=newbill now -all
	$cisis_dir/mx $DB_BILL append=newbill now -all
	$cisis_dir/mx newbill create=$DB_BILL now -all
else
	$cisis_dir/mx null count=1 "proc='a95{',date,'{'" create=$DB_BILL now -all
fi
$cisis_dir/mx $DB_BILL fst=@$conversor_dir/fst/bill.fst fullinv=$DB_BILL 

if [ -f $DB_CTRL_BG.mst ]
then
	$cisis_dir/mx null count=0 create=temp  now -all
	$cisis_dir/mx $DB_PRESUPUESTOS btell=0 "bool=$BUDGETID" "proc='a333{',ref(['$DB_CTRL_BG']l(['$DB_CTRL_BG']v1),v2),'{'" "proc='d*a1{',v1,'{a2{',if v333='' then '0' else v333 fi,'{'" append=temp now -all

	$cisis_dir/mx $DB_CTRL_BG btell=0 "bool=$BUDGETID" "proc='d*'" copy=$DB_CTRL_BG  now -all
	$cisis_dir/mx temp append=$DB_CTRL_BG  now -all
else
	$cisis_dir/mx $DB_PRESUPUESTOS "proc='d*a1{',v1,'{a2{0{'" append=$DB_CTRL_BG now -all
fi
$cisis_dir/mx $DB_CTRL_BG fst=@$conversor_dir/fst/budget.fst fullinv=$DB_CTRL_BG 

$cisis_dir/mx null count=1 "pft=replace(date,' ','_')" now > temp
BATCHBGID=`cat temp`

$cisis_dir/mx null count=1 "proc='a1{$BUDGETID{a100{$BATCHBGID{a190{',date,'{a2{',ref(['$DB_CTRL_BG']l(['$DB_CTRL_BG']s('$BUDGETID')),v2),'{a102{',ref(['$DB_CTRL_BG']l(['$DB_CTRL_BG']s('$BUDGETID')),v2),'{a200{$FIRST_YEAR_OF_RECENT_FEE{a201{$RECENT_FEE{a202{$BACKFILES_FEE{'" append=$DB_BATCH_RUN_BUDGET now -all
$cisis_dir/mx $DB_BATCH_RUN_BUDGET fst=@$conversor_dir/fst/budget.fst fullinv=$DB_BATCH_RUN_BUDGET 
