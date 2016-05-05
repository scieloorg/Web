. crossref_config.sh
BUDGETID=$1
BATCHID=$2
$cisis_dir/mx cipar=$MYCIPFILE DB_PRESUPUESTOS btell=0 "bool=$BUDGETID" lw=9999  "pft='REPORT date: ',date,#,'BUDGET ID:       ',v1/,'BUDGET date:       ',v3/,'BUDGET received: $ ',v2/" now 
$cisis_dir/mx cipar=$MYCIPFILE DB_BATCH_RUN_BUDGET btell=0 "bool=$BUDGETID" lw=9999  "pft=@$conversor_dir/pft/budget_report.pft" now 

echo
echo ARTIGOS PROCESSADOS EN ESTA EJECUCION
$cisis_dir/mx cipar=$MYCIPFILE DB_BILL btell=0 "bool=batchid=$BATCHID AND subm=error" count=1 "pft='ERRORS'/" now
$cisis_dir/mx cipar=$MYCIPFILE DB_BILL btell=0 "bool=batchid=$BATCHID AND subm=error" lw=9999  "pft=#,'PID=',v880/,'log file: ../output/crossref/log/',v30^x/,'fecha de procesamiento:',v10/" now 

$cisis_dir/mx cipar=$MYCIPFILE DB_BILL btell=0 "bool=batchid=$BATCHID AND NOT subm=error" count=1 "pft='SUCCESS'/" now
$cisis_dir/mx cipar=$MYCIPFILE DB_BILL btell=0 "bool=batchid=$BATCHID AND NOT subm=error" lw=9999  "pft=#,'PID=',v880/,'status: ',v30^*/,'fecha de procesamiento:',v10/" now 

echo FIM DEL INFORME


$cisis_dir/mx cipar=$MYCIPFILE DB_BILL btell=0 "bool=subm=error" count=1 "pft='ERRORS'/" now > ../output/crossref/report_error.txt
$cisis_dir/mx cipar=$MYCIPFILE DB_BILL btell=0 "bool=subm=error" lw=9999  "pft=#,'PID=',v880/,'log file: ../output/crossref/log/',v30^x/,'fecha de procesamiento:',v10/" now >> ../output/crossref/report_error.txt

if [ -f ../output/crossref/report_error.txt ]
then
	echo Artigos con errores en ../output/crossref/report_error.txt
fi
