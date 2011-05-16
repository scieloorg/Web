# Script principal para criar relatorios de avaliacao de permanencia
#
# lista opcional para selecionar apenas alguns titulos
OPTIONAL_ACRON_LIST=$1

. ./shs/read_config.sh

sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Executing $0 $1 $2 $3 $4 $5"

###############################################
#
#    PREPARATION
#
sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Apaga/cria arquivos e diretorios"
if [ -d "$APP_TEMP_PATH" ]
then
	rm -rf "$APP_TEMP_PATH"
fi
mkdir -p "$APP_TEMP_PATH"
if [ -f $FILE_LOG ]
then
	rm $FILE_LOG
fi
if [ -d $PATH_OUTPUT ]
then
    rm -rf $PATH_OUTPUT
fi
mkdir -p $PATH_OUTPUT

sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Prepare gizmos"
sh ./$PATH_COMMON_SHELLS/prepareGizmos.bat $READ_CONFIG

###############################################
#
#    SELECT JOURNALS
#
sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Cria uma lista com dados de TITLE"
sh ./$PATH_LIST_MODULE/select_journals.sh $READ_CONFIG $TITLELIST $OPTIONAL_ACRON_LIST

###############################################
#
#    SELECT ISSUES
#
sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Seleciona issues"
if [ -f $FILE_ALL_SELECTED_ISSUES.txt ]
then
    rm $FILE_ALL_SELECTED_ISSUES.txt
fi
$MX "seq=$TITLELIST" lw=9999 "pft=if p(v3) then 'sh ./$PATH_LIST_MODULE/select_journal_issues.sh $READ_CONFIG ',v2,' ',v3,' $PATH_OUTPUT/',v3,'/selected_issues $FILE_ALL_SELECTED_ISSUES.txt'/ fi" now  > $APP_TEMP_PATH/select_journal_issues.sh
sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Executa $APP_TEMP_PATH/select_journal_issues.sh"
sh $APP_TEMP_PATH/select_journal_issues.sh

###############################################
#
#   AFFILIATIONS
#
sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Cria uma lista/base de aff mais completa"
sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Executa ./$PATH_AFF_MODULE/main_improve_aff.sh $READ_CONFIG $FILE_ALL_SELECTED_ISSUES.txt $DB_v10v70 $DB_v70_completa"
sh ./$PATH_AFF_MODULE/main_improve_aff.sh $READ_CONFIG $FILE_ALL_SELECTED_ISSUES.txt $DBv10v70 $DBv70completa

###############################################
#
#   GENERATE REPORTS
#

#sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Inicia a pagina de relatorio"
#more ./pft/html.00.pft > $HTML_FILE_OUTPUT

sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Journals"
$MX "seq=$TITLELIST" lw=9999 "pft=if p(v3) then 'sh ./$PATH_APP_SHS/generate_journal_report.sh $READ_CONFIG ',v2,' ',v3,' '/ fi" now  > $APP_TEMP_PATH/je_call.bat
sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Executa $APP_TEMP_PATH/je_call.bat "
sh $APP_TEMP_PATH/je_call.bat

#more ./pft/html.99.pft >> $HTML_FILE_OUTPUT
#ls -l $HTML_FILE_OUTPUT
