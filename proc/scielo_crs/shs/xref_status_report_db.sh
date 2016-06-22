
. crossref_config.sh

DOIDB=$scielo_dir/bases-work/doi/doi

./xref_update_single_doidb.sh

echo Generating $MYTEMP/xref_status_report.txt
$cisis_dir/mx btell=0 $ARTIGO_DB tp=h "proc='d8000d8001d8002d8003d8004d8005d8006a8000{$depositor_prefix{a8001{$XREF_DOI_REPORT{a8002{$DB_BILL{a8003{$DOIDB{a8004{$FIRST_YEAR_OF_RECENT_FEE{a8005{$BACKFILES_FEE{a8006{$RECENT_FEE{'" "proc=@../prc/xref_status_report.prc" lw=9999 "pft=@../pft/xref_status_report.pft" now > $MYTEMP/xref_status_report.txt

# pid
# pubdate
# xml/subm DATE
# status,
# bill DATE
# price
# display DATE
# doi
echo Generating $XREF_DB_PATH/xref_status_report
$cisis_dir/mx seq=$MYTEMP/xref_status_report.txt create=$XREF_DB_PATH/xref_status_report now -all

echo Add estimated price $XREF_DB_PATH/xref_status_report 
$cisis_dir/mx $XREF_DB_PATH/xref_status_report "proc='d8004d8005d8006a8004{$FIRST_YEAR_OF_RECENT_FEE{a8005{$BACKFILES_FEE{a8006{$RECENT_FEE{'" "proc=@../prc/xref_status_report_add_estimated_price.prc" "proc='d8004d8005d8006'" copy=$XREF_DB_PATH/xref_status_report now -all
$cisis_dir/mx $XREF_DB_PATH/xref_status_report fst=@../fst/xref_status_report.fst fullinv=$XREF_DB_PATH/xref_status_report

echo END
