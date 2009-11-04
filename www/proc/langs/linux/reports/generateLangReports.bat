. langs/config/config.inc

echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5 > $PROCLANG_REPORT_LOG
echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5

if [ ! -d $REPORTS_PATH ]
then
  mkdir -p  $REPORTS_PATH
fi

chmod 775 ./$BATCHES_PATH/reports/common/*.bat
chmod 775 ./$BATCHES_PATH/common/*.bat
./$BATCHES_PATH/reports/common/generateDB4Tab.bat $FILE_CONFIG
./$BATCHES_PATH/common/generateGizmos.bat $FILE_CONFIG

$MX $DBLANG fst=@$PROCLANG_PATH/fst/lang.fst fullinv=$DBLANG

echo Geral >> $PROCLANG_REPORT_LOG
# GERAR PARA O GERAL
$BATCHES_PATH/reports/common/call_generateReport.bat $FILE_CONFIG $ $REPORTS_PATH/report_full ALL


echo  PARA cada titulo >> $PROCLANG_REPORT_LOG
# GERAR PARA cada titulo

# $MX $TITLE lw=9999 "pft='$BATCHES_PATH/reports/common/call_generateReport.bat $FILE_CONFIG ISSN=',v400,' $REPORTS_PATH/report_',v68,' ISSN'/" now > temp/langs_report_title.bat
$MX $DBLANG   btell=0  $ lw=9999 "pft=if p(v880) then '$BATCHES_PATH/reports/common/call_generateReport.bat $FILE_CONFIG ISSN=',v880*1.9,' $REPORTS_PATH/report_',v880*1.9,' ISSN'/ fi" now | sort -u > temp/langs_report_title.bat
chmod 775 temp/langs_report_title.bat
./temp/langs_report_title.bat

echo PARA cada ano >> $PROCLANG_REPORT_LOG
# GERAR PARA cada ano
# $MX cipar=$FILE_CIPAR ARTIGO btell=0 tp=i lw=9999 "pft=v65*0.4/" now | sort -u > temp/langs_years.seq

$MX $DBLANG  btell=0  $ "pft=if p(v880) then  v880*10.4 fi/" now | sort -u > temp/langs_years.seq
$MX seq=temp/langs_years.seq lw=9999 "pft='$BATCHES_PATH/reports/common/call_generateReport.bat $FILE_CONFIG YEAR=',v1,' $REPORTS_PATH/report_',v1,' YEAR'/" now > temp/langs_report_year.bat
chmod 775 temp/langs_report_year.bat
./temp/langs_report_year.bat
echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5 >> $PROCLANG_REPORT_LOG
echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5 