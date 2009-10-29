# Param 1 issn
# Param 2 count


chmod  775 journalEvaluation/*/linux/*.bat


. journalEvaluation/current/config/config.inc


./$PATH_SHELL/prepareGizmos.bat journalEvaluation/current/config/config.inc


if [ -f temp/avaliacao_afiliacoes.txt ]
then
	rm temp/avaliacao_afiliacoes.txt
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

# cria uma scilista com dados de TITLE
./$PATH_SHELL/generateJournalList.bat journalEvaluation/current/config/config.inc

vi $SCILISTA

# FAZ UMA SELECAO DE FASCICULOS
if [ -f temp/allselectedissues.txt ]
then
    rm temp/allselectedissues.txt
fi
$MX "seq=$SCILISTA" lw=9999 "pft=if p(v3) then './$PATH_SHELL/getJournalSelectedIssues.bat $1 ',v2,' ',v3,' temp/selectedissues',v3,'.txt'/,'cat temp/selectedissues',v3,'.txt >> $SEQFILEALLISSUESELECTED'/ fi" now  > temp/avaliacao_aff.bat

# cria uma lista/base de aff mais completa
./$PATH_SHELL/improveAff.bat journalEvaluation/current/config/config.inc

# inicia a pagina de relatorio
more $PATH_COMMON/pft/html.00.pft > $HTML_FILE

echo Journals
$MX "seq=$SCILISTA" lw=9999 "pft=if p(v3) then './$PATH_SHELL/getJournalInfo.bat $1 ',v2,' ',v3,/ fi" now  > temp/avaliacao_call.bat
chmod 775 temp/avaliacao_call.bat
./temp/avaliacao_call.bat 
# >log/avaliacao_geral.log


more $PATH_COMMON/pft/html.99.pft >> $HTML_FILE


ls -l $HTML_FILE