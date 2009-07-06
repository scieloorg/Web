. crossref_config.sh

if [ ! -f $DB_BILL.mst ]
then
	$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB btell=0 "tp=h" "proc='d*a880{',v880,'{a881{',v881,'{a65{',v65,'{a223{',v223,'{'" append=$DB_BILL now -all
	$cisis_dir/mx $DB_BILL fst=@$conversor_dir/fst/bill.fst fullinv=$DB_BILL 
fi

if [ ! -f $DB_BG.mst ]
then
	$cisis_dir/mx null count=1 lw=9999 "pft='budget id|budget|date|saldo|first_year|recent fee|back files fee|last article order|last selected|value exceeded',#" now > $DB_BG.seq
	$cisis_dir/mx null count=1 lw=9999 "pft='$BUDGETID|$BUDGET|$BUDGETDATE|0|$FIRST_YEAR_OF_RECENT_FEE|$RECENT_FEE|$BACKFILES_FEE|||0',#" now >> $DB_BG.seq

	#more $DB_BG.seq
	#read
	$cisis_dir/mx seq=$DB_BG.seq create=$DB_BG  now -all
	$cisis_dir/mx $DB_BG fst=@$conversor_dir/fst/budget.fst fullinv=$DB_BG 
fi
