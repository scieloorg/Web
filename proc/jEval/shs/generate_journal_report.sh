# Param 1 ARQUIVO DE CONFIGURACAO
# Param 2 issn
# Param 3 ACRON
echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5

. $1
ISSN=$2
ACRON=$3

PROCESS_DATE=`date +%Y%m%d%H%M%s`
J_DIR=$ACRON
JOURNAL_PATH_OUTPUT=$PATH_OUTPUT/$J_DIR/

OUTPUT_JOURNAL_REPORT=$JOURNAL_PATH_OUTPUT/$JOURNAL_REPORT_FILENAME
JOURNAL_LINK=$REL_PATH_OUTPUT/$J_DIR/$JOURNAL_REPORT_FILENAME

OUTPUT_BASIC_DATA_REPORT=$JOURNAL_PATH_OUTPUT/dados_basicos.csv

OUTPUT_DOCTOPIC_REPORT=$JOURNAL_PATH_OUTPUT/doctopic.csv
OUTPUT_HISTORY_REPORT=$JOURNAL_PATH_OUTPUT/history.csv
OUTPUT_ISSUES_REPORT=$JOURNAL_PATH_OUTPUT/issue
OUTPUT_AUTHORS_REPORT=$JOURNAL_PATH_OUTPUT/authors.csv

if [ ! -d $JOURNAL_PATH_OUTPUT ]
then 
    mkdir -p $JOURNAL_PATH_OUTPUT
fi

echo $REPORT_TITLE > $JOURNAL_PATH_OUTPUT/report_title.csv

echo journal $ACRON
#$MX cipar=$FILE_CIPAR TITLE btell=0 "loc=$ISSN" lw=9999 "pft='<p><a href=\"$J_DIR/$JOURNAL_REPORT_FILENAME\">',v100,'</a></p>'" now >> $HTML_FILE_OUTPUT

####################################
# DADOS BASICOS DE TITLE
####################################
sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG $ACRON Basic data
$MX cipar=$FILE_CIPAR TITLE btell=0 "loc=$ISSN" lw=9999 gizmo=$PATH_GZM/gizmoFreq,340 gizmo=$PATH_GZM/gizmoCountry,310 "pft=@$PATH_TEMPLATE/journal.pft" now > $OUTPUT_BASIC_DATA_REPORT



####################################
# DADOS DOS FASCICULOS
####################################
sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG $ACRON Issues data


$MX $JOURNAL_PATH_OUTPUT/selected_issues lw=9999 "pft=if size(v1)>0 then 'sh ./$PATH_APP_SHS/generate_issues_data.sh $1 ',v1,' $JOURNAL_PATH_OUTPUT ',if ref(mfn+1,v1)='' then 'LAST' else f(val(mfn),1,0) fi,' $OUTPUT_DOCTOPIC_REPORT $OUTPUT_HISTORY_REPORT $OUTPUT_ISSUES_REPORT $OUTPUT_AUTHORS_REPORT',# fi" now > $APP_TEMP_PATH/je_generate_issues_data.sh
sh $APP_TEMP_PATH/je_generate_issues_data.sh


####################################
# JUNTA TODOS OS RELATORIOS DO PERIODICO
####################################
echo $ACRON $PROCESS_DATE > $OUTPUT_JOURNAL_REPORT
echo "====================" >> $OUTPUT_JOURNAL_REPORT
echo $ACRON DADOS PERIODICO >> $OUTPUT_JOURNAL_REPORT
echo "====================" >> $OUTPUT_JOURNAL_REPORT
$MX "seq=$OUTPUT_BASIC_DATA_REPORT?" lw=9999 "pft=v1/"  now >> $OUTPUT_JOURNAL_REPORT

echo "====================" >> $OUTPUT_JOURNAL_REPORT
echo $ACRON DADOS FASCICULOS >> $OUTPUT_JOURNAL_REPORT
echo "====================" >> $OUTPUT_JOURNAL_REPORT
$MX "seq=$OUTPUT_ISSUES_REPORT.LAST.csv?" gizmo=$GZM_PIPE2TAB lw=9999 "pft=v1/"  now >> $OUTPUT_JOURNAL_REPORT

echo "====================" >> $OUTPUT_JOURNAL_REPORT
echo $ACRON TEMPO ENTRE RECEBIDO E ACEITO >> $OUTPUT_JOURNAL_REPORT
echo "====================" >> $OUTPUT_JOURNAL_REPORT
$MX "seq=$OUTPUT_HISTORY_REPORT?" gizmo=$GZM_PIPE2TAB lw=9999 "pft=v1/"  now >> $OUTPUT_JOURNAL_REPORT

echo "====================" >> $OUTPUT_JOURNAL_REPORT
echo $ACRON DOCTOPIC >> $OUTPUT_JOURNAL_REPORT
echo "====================" >> $OUTPUT_JOURNAL_REPORT
$MX "seq=$OUTPUT_DOCTOPIC_REPORT?" gizmo=$GZM_PIPE2TAB lw=9999 "pft=v1/"  now >> $OUTPUT_JOURNAL_REPORT


echo "====================" >> $OUTPUT_JOURNAL_REPORT
echo $ACRON AUTORES ARTIGOS >> $OUTPUT_JOURNAL_REPORT
echo "====================" >> $OUTPUT_JOURNAL_REPORT
$MX "seq=$OUTPUT_AUTHORS_REPORT?" gizmo=$GZM_PIPE2TAB lw=9999 "pft=v1/"  now >> $OUTPUT_JOURNAL_REPORT


echo +++++++++++++++
echo $OUTPUT_JOURNAL_REPORT
echo +++++++++++++++