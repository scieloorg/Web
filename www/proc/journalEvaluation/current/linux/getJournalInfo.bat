# Param 1 ARQUIVO DE CONFIGURACAO
# Param 2 issn
# Param 3 ACRON

. $1
PROCESS_DATE=`date +%Y%m%d%H%M%s`
# ./$PATH_SHELL/getJournalInfo.bat ',v2,' $ISSUEQTD $MX $CPFILE $OUTPUT_PATH ',v3,' $rel $HTML_FILE $JOURNAL_EDBOARD_HTML_PATH'/ fi

ISSN=$2
ACRON=$3


J_DIR=$ACRON
JOURNAL_OUTPUT_PATH=$OUTPUT_PATH/$J_DIR/

JournalFile=$OUTPUT_PATH/$J_DIR/$JournalFileName
JOURNAL_LINK=$REL_OUTPUT_PATH/$J_DIR/$JournalFileName

INPUT_FOR_HISTORY_PROC=$JOURNAL_OUTPUT_PATH/history
FILE_AUTHORS=$JOURNAL_OUTPUT_PATH/authors
OUTPUT_EDBOARD=$JOURNAL_OUTPUT_PATH/edBoard

if [ -d $OUTPUT_PATH/$ACRON ]
then 
	rm -rf $JOURNAL_OUTPUT_PATH
fi
mkdir -p $JOURNAL_OUTPUT_PATH

echo journal ...
echo $ACRON
$MX cipar=$CPFILE TITLE btell=0 "loc=$ISSN" lw=9999 "pft='<p><a href=\"$J_DIR/$JournalFileName\">',v100,'</a></p>'" now >> $HTML_FILE_OUTPUT

./$PATH_SHELL/WriteLog.bat $AVALLOG $ACRON Basic data
$MX cipar=$CPFILE TITLE btell=0 "loc=$ISSN" lw=9999 gizmo=$PATH_GZM/gizmoFreq,340 gizmo=$PATH_GZM/gizmoCountry,310 "pft=@$PATH_TEMPLATE/journal.pft" now > $JOURNAL_OUTPUT_PATH/dados_basicos.seq


./$PATH_SHELL/WriteLog.bat $AVALLOG $ACRON Authors History Afiliations


$MX seq=selectedissues$ACRON.txt lw=9999 "pft='./$PATH_SHELL/getIssuesInfo.bat $ISSN ',v1,' $ACRON $FILE_AUTHORS $INPUT_FOR_HISTORY_PROC'/" now >temp/avaliacao_lastIssues.bat
chmod 775 temp/avaliacao_lastIssues.bat
./temp/avaliacao_lastIssues.bat


echo $ACRON $PROCESS_DATE >> $JournalFile

echo $ACRON DADOS BASICOS >> $JournalFile
# echo $PATH_GZM/tab
$MX "seq=$JOURNAL_OUTPUT_PATH/dados_basicos.seq¨" gizmo=$PATH_GZM/tab lw=9999 "pft=v1/"  now >> $JournalFile

if [ -f $OUTPUT_EDBOARD ]
then
    rm $OUTPUT_EDBOARD
fi
./$PATH_SHELL/getEdBoard.bat $ISSN $ACRON $OUTPUT_EDBOARD

echo $ACRON CORPO EDITORIAL >> $JournalFile
more $OUTPUT_EDBOARD >> $JournalFile

echo $ACRON AUTORES ARTIGOS >> $JournalFile
$MX "seq=$FILE_AUTHORS.seq¨" gizmo=$PATH_GZM/tab lw=9999  "pft=v1/"  now >> $JournalFile

if [ "@$PARAM_SELECT_BY_YEAR" != "@" ]
then
    echo $ACRON DOCTOPIC >> $JournalFile
    ./$PATH_DOCTOPIC_SHELLS/doctopic_call_genLangReport.bat $FILE_CONFIG $ISSN temp/je_replang.txt
    more temp/je_replang.txt >> $JournalFile

    $MX cipar=$CPFILE ISSUE btell=0 "bool=$ISSN$PARAM_SELECT_BY_YEAR$" "tab=if v32<>'ahead' and v32<>'review' and a(v41) then v35 fi" now > temp/je_numbers
    $MX cipar=$CPFILE ARTIGO btell=0 "bool=hr=s$ISSN$PARAM_SELECT_BY_YEAR$" "tab=if v32<>'ahead' and v32<>'review' and a(v41) then v880*1.13 fi" now >> temp/je_numbers
    $MX cipar=$CPFILE ISSUE btell=0 "bool=$ISSN$PARAM_SELECT_BY_YEAR$" "pft=if v32<>'ahead' and v32<>'review' and a(v41) then v35,v36*0.4,s(f(10000+val(v36*4),1,0))*1,s(f(100000+val(v122),1,0))*1 fi" now |sort -r > temp/je_issues
    $MX seq=temp/je_issues count=1 "pft=v1/" now > temp/je_lastissue
    f = "000100001"
    l = `cat temp/je_lastissue`
    $MX cipar=$CPFILE ARTIGO btell=0 "bool=hr=s$ISSN$PARAM_SELECT_BY_YEAR$f" "pft=if p(v14^f) then s(f(10000000+val(v14^f),1,0))*1 fi,'|',if p(v14^l) then s(f(10000000+val(v14^l),1,0))*1 fi/" now > temp/je_pages
    $MX cipar=$CPFILE ARTIGO btell=0 "bool=hr=s$l" "pft=if p(v14^f) then s(f(10000000+val(v14^f),1,0))*1 fi,'|',if p(v14^l) then s(f(10000000+val(v14^l),1,0))*1 fi/" now >> temp/je_pages
    $MX seq=temp/je_pages create=temp/je_pages now -all
    $MX seq=temp/je_pages "pft=f(val(ref(2,v1))-val(v1),1,0)" now >> temp/je_numbers

    more temp/je_numbers >> $JournalFile

fi

echo $ACRON RECEBIDOS ACEITOS >> $JournalFile
#$MX "seq=$INPUT_FOR_HISTORY_PROC.seq¨" gizmo=$PATH_GZM/tab lw=9999  "pft=v1/"  now >> $JournalFile
