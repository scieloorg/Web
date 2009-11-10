# Param 1 ARQUIVO DE CONFIGURACAO
# Param 2 issn
# Param 3 ACRON
echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5

. $1
ISSN=$2
ACRON=$3

PROCESS_DATE=`date +%Y%m%d%H%M%s`
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

echo journal $ACRON
$MX cipar=$CPFILE TITLE btell=0 "loc=$ISSN" lw=9999 "pft='<p><a href=\"$J_DIR/$JournalFileName\">',v100,'</a></p>'" now >> $HTML_FILE_OUTPUT

./$PATH_COMMON_SHELLS/WriteLog.bat $AVALLOG $ACRON Basic data
$MX cipar=$CPFILE TITLE btell=0 "loc=$ISSN" lw=9999 gizmo=$PATH_GZM/gizmoFreq,340 gizmo=$PATH_GZM/gizmoCountry,310 "pft=@$PATH_TEMPLATE/journal.pft" now > $JOURNAL_OUTPUT_PATH/dados_basicos.seq


./$PATH_COMMON_SHELLS/WriteLog.bat $AVALLOG $ACRON Authors History Afiliations
$MX seq=$FILE_SELECTED_ISSUES$ACRON.txt lw=9999 "pft='./$PATH_CURRENT_SHELLS/getIssuesInfo.bat $1 ',v1,' $ISSN $ACRON $FILE_AUTHORS $INPUT_FOR_HISTORY_PROC'/" now >temp/je_lastIssues.bat
chmod 775 temp/je_lastIssues.bat
./temp/je_lastIssues.bat


echo $ACRON $PROCESS_DATE >> $JournalFile

echo $ACRON DADOS BASICOS >> $JournalFile
# echo $GZM_2TAB
$MX "seq=$JOURNAL_OUTPUT_PATH/dados_basicos.seq¨" gizmo=$GZM_2TAB lw=9999 "pft=v1/"  now >> $JournalFile

if [ -f $OUTPUT_EDBOARD ]
then
    rm $OUTPUT_EDBOARD
fi
./$PATH_CURRENT_SHELLS/getEdBoard.bat $ISSN $ACRON $OUTPUT_EDBOARD

echo $ACRON CORPO EDITORIAL >> $JournalFile
more $OUTPUT_EDBOARD >> $JournalFile

echo $ACRON AUTORES ARTIGOS >> $JournalFile
$MX "seq=$FILE_AUTHORS.seq¨" gizmo=$GZM_2TAB lw=9999 "pft=v1/"  now >> $JournalFile

echo $ACRON DOCTOPIC >> $JournalFile

echo $ACRON RECEBIDOS ACEITOS >> $JournalFile
#$MX "seq=$INPUT_FOR_HISTORY_PROC.seq¨" gizmo=$GZM_2TAB lw=9999  "pft=v1/"  now >> $JournalFile
