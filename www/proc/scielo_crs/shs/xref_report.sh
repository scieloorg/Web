. crossref_config.sh
BUDGETID=$1
$cisis_dir/mx cipar=$MYCIPFILE DB_PRESUPUESTOS btell=0 "bool=$BUDGETID" lw=9999  "pft='REPORT date: ',date,#,'BUDGET ID:       ',v1/,'BUDGET date:       ',v3/,'BUDGET received: $ ',v2/" now 
$cisis_dir/mx cipar=$MYCIPFILE DB_BATCH_RUN_BUDGET btell=0 "bool=$BUDGETID" lw=9999  "pft=@$conversor_dir/pft/budget_report.pft" now 

echo FIM DEL INFORME