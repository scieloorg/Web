# Param 1 issn
# Param 2 count

# lista opcional para selecionar apenas alguns titulos
SCILISTAOPCIONAL=$1

echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5

chmod  775 journalEvaluation/*/linux/*.bat
. journalEvaluation/current/config/config.inc

echo `date '+%Y.%m.%d %H:%M:%S'` Prepare gizmos
./$PATH_COMMON_SHELLS/prepareGizmos.bat $FILE_CONFIG

echo `date '+%Y.%m.%d %H:%M:%S'` Apaga/cria arquivos e diretorios
if [ -f temp/je_afiliacoes.txt ]
then
	rm temp/je_afiliacoes.txt
fi
if [ -f log/avaliacao_permanencia.log ]
then
	rm log/avaliacao_permanencia.log
fi
if [ ! -d $OUTPUT_PATH ]
then
	mkdir -p $OUTPUT_PATH
fi
if [ -f $FILE_SELECTED_ISSUES ]
then
	rm $FILE_SELECTED_ISSUES
fi

echo Cria uma scilista com dados de TITLE
./$PATH_CURRENT_SHELLS/generateJournalList.bat $FILE_CONFIG $SCILISTAOPCIONAL
# vi $SCILISTA

# FAZ UMA SELECAO DE FASCICULOS
echo Seleciona issues
if [ -f $FILE_SELECTED_ISSUES.txt ]
then
    rm $FILE_SELECTED_ISSUES.txt
fi
$MX "seq=$SCILISTA" lw=9999 "pft=if p(v3) then './$PATH_CURRENT_SHELLS/getJournalSelectedIssues.bat $FILE_CONFIG ',v2,' ',v3,' $FILE_SELECTED_ISSUES',v3/,'cat $FILE_SELECTED_ISSUES',v3,'.seq >> $FILE_SELECTED_ISSUES.txt'/ fi" now  > temp/je_getJournalSelectedIssues.bat
chmod 775 temp/je_getJournalSelectedIssues.bat
./temp/je_getJournalSelectedIssues.bat

echo Cria uma lista/base de aff mais completa
./$PATH_CURRENT_SHELLS/improveAff.bat $FILE_CONFIG

echo inicia a pagina de relatorio
more $PATH_COMMON/pft/html.00.pft > $HTML_FILE

echo Journals
$MX "seq=$SCILISTA" lw=9999 "pft=if p(v3) then './$PATH_CURRENT_SHELLS/getJournalInfo.bat $FILE_CONFIG ',v2,' ',v3,' '/ fi" now  > temp/je_call.bat
chmod 775 temp/je_call.bat
./temp/je_call.bat 
# >log/avaliacao_geral.log


more $PATH_COMMON/pft/html.99.pft >> $HTML_FILE


ls -l $HTML_FILE