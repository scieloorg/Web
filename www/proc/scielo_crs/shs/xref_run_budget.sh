#
# This script is the main if there is a budget, otherwise the main script is the xref_run.sh
# This script accepts as parameters ORDER Descending or Ascending
# generates a list of articles sorted by publication date
# calculates the fee depending of the publication date according to the CrossRef policies
# then call xref_run.sh for each article
#

. crossref_config.sh
chmod 775 *.sh

ORDER=$1

SORTEDLIST=$MYTEMP/list

echo Este procesamiento generara un listado de PID para ser usado en el deposito de CrossRef
echo Considerando
echo BASE ARTIGO en ARTIGO_DB
echo cisis en $cisis_dir
echo ARTICULOS RECIENTES DESDE EL ANO $FIRST_YEAR_OF_RECENT_FEE
echo VALOR PARA ESTES ARTICULOS \$ $RECENT_FEE
echo VALOR PARA ARTICULOS ANTERIORES A $FIRST_YEAR_OF_RECENT_FEE \$ $BACKFILES_FEE
echo VALOR DISPONIBLE PARA EL PAGO $BUDGET

echo
if [ "$2" == "reseting" ]
then
	$conversor_dir/shs/xref_reseting.sh
fi
$conversor_dir/shs/xref_prepareEnvBudget.sh

if [ -f $SORTEDLIST.txt ]
then
	mv $SORTEDLIST.txt $MYTEMP/lixo
fi


if [ "@$ORDER" == "@Descending" ]
then
	echo ARTICULOS MAS RECIENTES PARA LOS MAS ANTIGUOS
	$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB btell=0  "tp=h" "proc='a9001{$FIRST_YEAR_OF_RECENT_FEE{a9002{$RECENT_FEE{a9003{$BACKFILES_FEE{a9005{$BUDGETID{'" lw=9999 "pft=@$conversor_dir/pft/xref_generateList.pft" now | sort -u -r > $SORTEDLIST.txt
else
	if [ "@$ORDER" == "@Ascending" ]
	then
		echo ARTICULOS MAS ANTIGUOS PARA LOS MAS RECIENTES
		$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB btell=0  "tp=h" "proc='a9001{$FIRST_YEAR_OF_RECENT_FEE{a9002{$RECENT_FEE{a9003{$BACKFILES_FEE{a9005{$BUDGETID{'" lw=9999 "pft=@$conversor_dir/pft/xref_generateList.pft" now | sort -u > $SORTEDLIST.txt
	else
		echo Informe el valor para ORDER Descending o Ascending
	fi
fi

echo Para seguir ENTER 
echo Para interrumpir CTRL+C
read

if [ -f $SORTEDLIST.txt ]
then
	$cisis_dir/mx cipar=$MYCIPFILE null count=0 create=$DB_BILL now -all
	
	$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB btell=0 "tp=h" "proc='d*a880{',v880,'{',|a881{|v881|{|,|a223{|v223|{|,'a65{',v65,'{',if l(['DB_BILL']if p(v881) then v881 else v880 fi)>0 then ref(['DB_BILL']l(['DB_BILL']if p(v881) then v881 else v880 fi), |a1{|v1|{|,|a2{|v2|{|,|a3{|v3|{|,|a4{|v4|{|) fi" append=$DB_BILL now -all
	$cisis_dir/mx $DB_BILL fst=@$conversor_dir/fst/bill.fst fullinv=$DB_BILL now -all

	# $cisis_dir/mx "seq=$SORTEDLIST.txt " create=$SORTEDLIST now -all
	# $cisis_dir/mx cipar=$MYCIPFILE $SORTEDLIST lw=99999 "pft='$conversor_dir/shs/xref_run_budget_calculateFee.sh ',v1,' ',v2,' ',v3,' $cisis_dir $MYCIPFILE $BUDGETID ',ref(['DB_BG']s('$BUDGETID'),v2)/" now > $MYTEMP/xref_run_budget_calculateFee.sh


	$cisis_dir/mx cipar=$MYCIPFILE "seq=$SORTEDLIST.txt " lw=99999 "pft='$conversor_dir/shs/xref_run_budget_calculateFee.sh ',v1,' ',v2,' ',v3,' $cisis_dir $MYCIPFILE $BUDGETID ',ref(['DB_BG']l(['DB_BG']'$BUDGETID'),v2),' ',mfn/" now > $MYTEMP/xref_run_budget_calculateFee.sh

	chmod 775 $MYTEMP/xref_run_budget_calculateFee.sh
	$MYTEMP/xref_run_budget_calculateFee.sh
	
	$cisis_dir/mx cipar=$MYCIPFILE DB_BG btell=0 "bool=$BUDGETID" lw=9999 "pft=@$conversor_dir/pft/budget_report.pft" now 

fi
###
# DB_BG
#   1 id 
#   2 budget
#   3 date
#   4 saldo
####
###
# DB_BILL
#   880 pid 
#   1 budget
#   2 fee
#   3 date
#   4 status
####
