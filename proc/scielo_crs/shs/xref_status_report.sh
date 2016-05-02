

. crossref_config.sh

REPORT_PATH=$conversor_dir/output/status
cd $database_dir/doi
find . -name "*.mst" > $MYTEMP/doi_displayed_list.txt

$cisis_dir/mx seq=$MYTEMP/doi_displayed_list.txt lw=9999 "pft=if not v1:'alldoi' and not v1:'controler' then '$cisis_dir/mx ',replace(replace(v1,'.mst',''),'./',''),' append=$MYTEMP/alldoi now -all'/ fi" now > $MYTEMP/doi_displayed_list.sh
chmod 754 $MYTEMP/doi_displayed_list.sh
$MYTEMP/doi_displayed_list.sh

$cisis_dir/mx $MYTEMP/alldoi fst=@$conversor_dir/fst/doi.fst fullinv=$MYTEMP/alldoi
cd $conversor_dir/shs

echo Generating ...
$cisis_dir/mx btell=0 $ARTIGO_DB tp=h "proc='d8000d8001d8002d8003d8100d8101d8102a8000{$depositor_prefix{a8001{$XREF_DOI_REPORT{a8002{$DB_BILL{a8003{$MYTEMP/alldoi{a8100{$FIRST_YEAR_OF_RECENT_FEE{a8101{$BACKFILES_FEE{a8102{$RECENT_FEE{" "proc=@../prc/xref_status_report.prc" lw=9999 "pft=@../pft/xref_status_report.pft" now > $MYTEMP/doi_status_report.txt

# pid
# pubdate
# xml/subm DATE
# status,
# bill DATE
# price
# display DATE
# doi
$cisis_dir/mx seq=$MYTEMP/doi_status_report.txt create=$XREF_DB_PATH/doi_status_report
$cisis_dir/mx $XREF_DB_PATH/doi_status_report fst=@../fst/doi_status_report.fst fullinv=$XREF_DB_PATH/doi_status_report

#1 0 mpl,'PID='v1
#2 0 mpl,'PUBDATE='v2
#3 0 mpl,'DEPOSIT_DATE='v3
#4 0 mpl,'DEPOSIT_STATUS='v4
#5 0 mpl,'BILL_DATE='v5
#6 0 mpl,'BILL_PRICE='v6
#7 0 mpl,'DISPLAY_DATE='v7
#8 0 mpl,'DISPLAY_DOI='v8

$cisis_dir/mx $XREF_DB_PATH/doi_status_report "DEPOSIT_STATUS=ERROR" lw=999 "pft=v1/" now > ${REPORT_PATH}_deposit_error.txt

$cisis_dir/mx $XREF_DB_PATH/doi_status_report "DEPOSIT_STATUS=" lw=999 "pft=v4,'|',v1,"

echo fim
