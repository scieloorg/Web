. crossref_config.sh

# taxa para artigos recentes

BATCHBGID=$1
PRIOR=$2

# FAZIA SENTIDO ESTAS LINHAS DO SCRIPT QUANDO VARRIA A BASE TODA, DANDO UMA PREVISAO DE GASTO FUTURO
# $cisis_dir/mx cipar=$MYCIPFILE DB_BILL btell=0 "bool=$PID" count=1 "proc='d4d100d121a4{dont{a2{$FEE{a3{',date,'{a1{$BUDGETID{a121{$PRIOR{a100{$BATCHBGID{'" copy=DB_BILL now -all	
# $cisis_dir/mx $DB_BILL fst=@$conversor_dir/fst/bill.fst fullinv=$DB_BILL now -all

# $cisis_dir/mx cipar=$MYCIPFILE DB_BATCH_RUN_BUDGET btell=0 "bool=BATCHBG=$BATCHBGID" "proc='d90d122d10a122{$PRIOR{a10{',f(val(v10)+val('$FEE'),1,2),'{a90{',date,'{'" copy=DB_BATCH_RUN_BUDGET now -all

$cisis_dir/mx cipar=$MYCIPFILE DB_BATCH_RUN_BUDGET btell=0 "bool=BATCHBG=$BATCHBGID" "proc='d90d122d10a122{$PRIOR{a10{unknow, but more than 0{a90{',date,'{'" copy=DB_BATCH_RUN_BUDGET now -all
