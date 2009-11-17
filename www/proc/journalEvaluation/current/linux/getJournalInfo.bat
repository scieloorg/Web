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
JOURNAL_LINK=$REL_PATH_OUTPUT/$J_DIR/$JournalFileName

JournalFile=$JOURNAL_PATH_OUTPUT/$JournalFileName

LOC_FILE_BASICDATA=$JOURNAL_PATH_OUTPUT/dados_basicos.seq
LOC_FILE_EDBOARD=$JOURNAL_PATH_OUTPUT/edBoard
LOC_FILE_AUTHORS=$JOURNAL_PATH_OUTPUT/authors
LOC_FILE_DOCTOPIC=temp/je_replang.txt
LOC_FILE_DOCTOPIC_SRC=$PATH_LANG_REPORTS/report_$ISSN\_year_doctopic.xls
LOC_FILE_DOCTOPIC_INPUT=$JOURNAL_PATH_OUTPUT/doctopic.xls
LOC_FILE_NUMBERS=$JOURNAL_PATH_OUTPUT/numbers
LOC_FILE_DATES=$JOURNAL_PATH_OUTPUT/history_dates
LOC_FILE_HISTORY=$JOURNAL_PATH_OUTPUT/history

LOC_FILE_JOURNAL=$JournalFile

$LOC_FILE_DOCTOPIC

if [ -d $JOURNAL_PATH_OUTPUT ]
then 
	rm -rf $JOURNAL_PATH_OUTPUT
fi
mkdir -p $JOURNAL_PATH_OUTPUT

echo journal $ACRON
$MX cipar=$FILE_CIPAR TITLE btell=0 "loc=$ISSN" lw=9999 "pft='<p><a href=\"$J_DIR/$JournalFileName\">',v100,'</a></p>'" now >> $HTML_FILE_OUTPUT

####################################
# DADOS BASICOS DE TITLE
####################################
./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG $ACRON Basic data
$MX cipar=$FILE_CIPAR TITLE btell=0 "loc=$ISSN" lw=9999 gizmo=$PATH_GZM/gizmoFreq,340 gizmo=$PATH_GZM/gizmoCountry,310 "pft=@$PATH_TEMPLATE/journal.pft" now > $LOC_FILE_BASICDATA

####################################
# EDITORIAL BOARD
####################################
if [ -f $LOC_FILE_EDBOARD ]
then
    rm $LOC_FILE_EDBOARD
fi
./$PATH_CURRENT_SHELLS/getEdBoard.bat $1 $ACRON $LOC_FILE_EDBOARD

####################################
# DADOS DOS FASCICULOS
####################################
./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG $ACRON Authors History Afiliations
if [ -f "$LOC_FILE_DATES" ]
then
    rm $LOC_FILE_DATES
fi
if [ -f "$LOC_FILE_NUMBERS.mst" ]
then
    rm $LOC_FILE_NUMBERS.*
fi
$MX seq=$FILE_SELECTED_ISSUES$ACRON.seq lw=9999 "pft=if size(v1)>0 then './$PATH_CURRENT_SHELLS/getIssuesInfo.bat $1 ',v1,' $ISSN $ACRON $LOC_FILE_AUTHORS $LOC_FILE_DATES $LOC_FILE_NUMBERS'/ fi" now > temp/je_getIssuesInfo.bat
chmod 775 temp/je_getIssuesInfo.bat
./temp/je_getIssuesInfo.bat

####################################
# DOCTOPIC LANGUAGES
####################################
cp $LOC_FILE_DOCTOPIC_SRC $LOC_FILE_DOCTOPIC_INPUT
if [ "@$PARAM_SELECT_BY_YEAR" == "@" ]
then
    YEAR=`cat temp/je_YEAR`
  ./$PATH_DOCTOPIC_SHELLS/doctopic_call_genLangReport.bat $FILE_CONFIG $ISSN $LOC_FILE_DOCTOPIC $LOC_FILE_DOCTOPIC_INPUT $YEAR
else
  ./$PATH_DOCTOPIC_SHELLS/doctopic_call_genLangReport.bat $FILE_CONFIG $ISSN $LOC_FILE_DOCTOPIC $LOC_FILE_DOCTOPIC_INPUT $PARAM_SELECT_BY_YEAR
fi

####################################
# DADOS DOS FASCICULOS - NUMEROS DE FASCICULOS, ARTIGOS, PAGINAS
####################################
$MX $LOC_FILE_NUMBERS count=1 "pft='Fascículos|',v2/" now > temp/je_xnumbers
$MX $LOC_FILE_NUMBERS from=2 count=1 "pft='Artigos|',v2/" now >> temp/je_xnumbers
$MX $LOC_FILE_NUMBERS from=3  "pft=v1/" now | sort > temp/je_pages.seq
$MX seq=temp/je_pages.seq count=1 "pft=v1/" now > temp/je_pages.txt
$MX $LOC_FILE_NUMBERS from=3  "pft=v2/" now | sort -r > temp/je_pages.seq
$MX seq=temp/je_pages.seq count=1 "pft=v1/" now >> temp/je_pages.txt
$MX seq=temp/je_pages.txt create=temp/je_pages now -all
$MX temp/je_pages count=1 "pft='Páginas|',f(val(ref(2,v1))-val(v1),1,0)/" now >> temp/je_xnumbers

####################################
# DADOS DOS FASCICULOS - HISTORICO ACEITO/RECEBIDO
####################################
./$PATH_DATE_DIFF/linux/calculateDateDiff.bat $1 $LOC_FILE_DATES $LOC_FILE_HISTORY.seq

####################################
# ESCREVE O RELATORIO DO TITULO
####################################
echo $ACRON $PROCESS_DATE > $LOC_FILE_JOURNAL
echo $ACRON DADOS BASICOS >> $LOC_FILE_JOURNAL
$MX "seq=$LOC_FILE_BASICDATA¨" gizmo=$GZM_PIPE2TAB lw=9999 "pft=v1/"  now >> $LOC_FILE_JOURNAL
echo $ACRON CORPO EDITORIAL >> $LOC_FILE_JOURNAL
more $LOC_FILE_EDBOARD >> $LOC_FILE_JOURNAL
echo $ACRON AUTORES ARTIGOS >> $LOC_FILE_JOURNAL
$MX "seq=$LOC_FILE_AUTHORS.seq¨" gizmo=$GZM_PIPE2TAB lw=9999 "pft=v1/"  now >> $LOC_FILE_JOURNAL
echo $ACRON DOCTOPIC >> $LOC_FILE_JOURNAL
$MX "seq=$LOC_FILE_DOCTOPIC¨" gizmo=$GZM_PIPE2TAB  lw=9999 "pft=v1/"  now >> $LOC_FILE_JOURNAL
echo $ACRON NUMBERS >> $LOC_FILE_JOURNAL
$MX "seq=temp/je_xnumbers¨" gizmo=$GZM_PIPE2TAB lw=9999 "pft=v1/"  now >> $LOC_FILE_JOURNAL
echo $ACRON RECEBIDOS ACEITOS >> $LOC_FILE_JOURNAL
$MX "seq=$LOC_FILE_HISTORY.seq¨" gizmo=$GZM_PIPE2TAB lw=9999 "pft=v1/"  now >> $LOC_FILE_JOURNAL

