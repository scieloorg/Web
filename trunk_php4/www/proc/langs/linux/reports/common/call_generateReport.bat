. $1

SELECTION=$2
RESULT_PATH=$3
# [ ALL | ISSN | YEAR ]
SELECTION_TYPE=$4


echo Executing $0 $1 $2 $3 $4 $5 $6 $7 >> $PROCLANG_REPORT_LOG

$MX seq=$PROCLANG_PATH/tables/guide_gen_tabALL.seq lw=9999 "pft=if instr(v1,'$SELECTION_TYPE=YES')=0 then '$BATCHES_PATH/reports/common/generateReport.bat $1 $SELECTION $RESULT_PATH ',v1/ fi" now > temp/langs_gen_reports.bat
chmod 775 temp/langs_gen_reports.bat
temp/langs_gen_reports.bat