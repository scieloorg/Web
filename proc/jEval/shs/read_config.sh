. ./config/config.app.sh

# APP
TEMPLATE=201101
PATH_TEMPLATE=templates/$TEMPLATE
READ_CONFIG=./shs/read_config.sh
FILE_CIPAR=$APP_TEMP_PATH/avaliacao.cip
FILE_ALL_SELECTED_ISSUES=$APP_TEMP_PATH/je_all_selected_issues
TITLELIST=$APP_TEMP_PATH/je_journal.lst
PATH_LIST_MODULE=tools/list
PATH_AFF_MODULE=tools/aff
PATH_APP_SHS=shs
PATH_CURRENT=shs
PATH_SEQ=seq
PATH_GZM=gizmo
PATH_COMMON_SHELLS=common
PATH_COMMON=common
PATH_DATE_DIFF=tools/calculateDateDiff

JOURNAL_REPORT_FILENAME=journaldata.xls
DBv70completa=bases/v70_completa
DBv10v70=$APP_TEMP_PATH/je_v10v70

GZM_TAB2PIPE=$APP_TEMP_PATH/je_gzm_tab2pipe
GZM_PIPE2TAB=$APP_TEMP_PATH/je_gzm_pipe2tab

DATEDB=$PATH_GZM/dates

echo TITLE.*=$TITLE.* > $FILE_CIPAR
echo ARTIGO.*=$ARTIGODB.* >>$FILE_CIPAR
echo ENTITY.*=gizmo/ent2ans.*>>$FILE_CIPAR
echo ISSUE.*=$ISSUEDB.* >>$FILE_CIPAR
