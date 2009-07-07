. crossref_config.sh

. $conversor_dir/shs/xref_prepareEnv.sh

BUDGETID=$1
if [ ! -f $DB_BILL.mst ]
then
	$cisis_dir/mx null count=0 create=$DB_BILL now -all
		
	$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB btell=0 "tp=h" "proc='d*a880{',v880,'{',|a881{|v881|{|,|a223{|v223|{|,'a65{',v65,'{'" append=$DB_BILL now -all

	$cisis_dir/mx $DB_BILL fst=@$conversor_dir/fst/bill.fst fullinv=$DB_BILL 
fi

$cisis_dir/mx "seq=db_presupuestos.txt " create=$DB_PRESUPUESTOS  now -all
$cisis_dir/mx $DB_PRESUPUESTOS fst=@$conversor_dir/fst/budget.fst fullinv=$DB_PRESUPUESTOS 

if [ -f $DB_CTRL_BG.mst ]
then
	$cisis_dir/mx null count=0 create=temp  now -all
	$cisis_dir/mx $DB_PRESUPUESTOS btell=0 "bool=$BUDGETID" "proc='d*a1{',v1,'{a2{0',ref(['$DB_CTRL_BG']l(['$DB_CTRL_BG']v1),v2),'{'" append=temp now -all
	$cisis_dir/mx temp create=$DB_CTRL_BG  now -all
else
	$cisis_dir/mx $DB_PRESUPUESTOS "proc='d*a1{',v1,'{a2{0{'" append=$DB_CTRL_BG now -all
fi
$cisis_dir/mx $DB_CTRL_BG fst=@$conversor_dir/fst/budget.fst fullinv=$DB_CTRL_BG 


$cisis_dir/mx null count=1 "pft=replace(date,' ','_')" now > temp
BATCHBGID=`cat temp`

$cisis_dir/mx null count=1 "proc='a1{$BUDGETID{a100{$BATCHBGID{a190{',date,'{a2{',ref(['$DB_CTRL_BG']l(['$DB_CTRL_BG']s('$BUDGETID')),v2),'{a102{',ref(['$DB_CTRL_BG']l(['$DB_CTRL_BG']s('$BUDGETID')),v2),'{'" append=$DB_BATCH_RUN_BUDGET now -all
$cisis_dir/mx $DB_BATCH_RUN_BUDGET fst=@$conversor_dir/fst/budget.fst fullinv=$DB_BATCH_RUN_BUDGET 
