# Script principal para criar relatorios de avaliacao de permanencia
#
# lista opcional para selecionar apenas alguns titulos
TITLELISTOPCIONAL=$1

echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5

chmod  775 jEval/*/*.bat
chmod  775 jEval/*/*/*.bat
chmod  775 jEval/*/*/*/*.bat
. jEval/current/config/config.inc

echo `date '+%Y.%m.%d %H:%M:%S'` Prepare gizmos
./$PATH_COMMON_SHELLS/prepareGizmos.bat $FILE_CONFIG

echo `date '+%Y.%m.%d %H:%M:%S'` Apaga/cria arquivos e diretorios
if [ -f "temp/je_*" ]
then
	rm "temp/je_*"
fi
if [ -f $FILE_LOG ]
then
	rm $FILE_LOG
fi
if [ -d $PATH_OUTPUT ]
then
    rm -rf $PATH_OUTPUT
fi
mkdir -p $PATH_OUTPUT

echo Cria uma lista com dados de TITLE
./$PATH_LIST_MODULE/list_generateJournalList.bat $FILE_CONFIG $TITLELISTOPCIONAL $TITLELIST

# FAZ UMA SELECAO DE FASCICULOS
echo Seleciona issues
if [ -f $FILE_SELECTED_ISSUES.txt ]
then
    rm $FILE_SELECTED_ISSUES.txt
fi
$MX "seq=$TITLELIST" lw=9999 "pft=if p(v3) then './$PATH_LIST_MODULE/list_generateJournalIssuesList.bat $FILE_CONFIG ',v2,' ',v3,' $FILE_SELECTED_ISSUES',v3,' $FILE_SELECTED_ISSUES.txt'/ fi" now  > temp/je_getJournalSelectedIssues.bat
chmod 775 temp/je_getJournalSelectedIssues.bat
./temp/je_getJournalSelectedIssues.bat

echo Cria uma lista/base de aff mais completa
./$PATH_AFF_MODULE/improveAff.bat $FILE_CONFIG $FILE_SELECTED_ISSUES.txt $SEQ_DB_v70 $DB_v70 $DB_v70_completa


echo inicia a pagina de relatorio
more $PATH_COMMON/pft/html.00.pft > $HTML_FILE_OUTPUT

echo Journals
$MX "seq=$TITLELIST" lw=9999 "pft=if p(v3) then './$PATH_CURRENT_SHELLS/getJournalInfo.bat $FILE_CONFIG ',v2,' ',v3,' '/ fi" now  > temp/je_call.bat
chmod 775 temp/je_call.bat
./temp/je_call.bat 

more $PATH_COMMON/pft/html.99.pft >> $HTML_FILE_OUTPUT
ls -l $HTML_FILE_OUTPUT