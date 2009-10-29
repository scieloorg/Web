# Param 1 ARQUIVO DE CONFIGURACAO
# Param 2 issn
# Param 3 ACRON

. $1
PROCESS_DATE=`date +%Y%m%d%H%M%s`
# ./$PATH_SHELL/getJournalInfo.bat ',v2,' $ISSUEQTD $MX $CPFILE $OUTPUT_PATH ',v3,' $rel $HTML_FILE $JOURNAL_EDBOARD_HTML_PATH'/ fi

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
$MX cipar=$CPFILE TITLE btell=0 "loc=$1" lw=9999 "pft='<p><a href=\"$J_DIR/$JournalFileName\">',v100,'</a></p>'" now >> $HTML_FILE_OUTPUT

./$PATH_SHELL/WriteLog.bat $AVALLOG $ACRON Basic data
$MX cipar=$CPFILE TITLE btell=0 "loc=$1" lw=9999 gizmo=$PATH_GZM/gizmoFreq,340 "pft=@$PATH_TEMPLATE/journal.pft" now > $JOURNAL_OUTPUT_PATH/dados_basicos.seq


./$PATH_SHELL/WriteLog.bat $AVALLOG $ACRON Authors History Afiliations


$MX seq=selectedissues$ACRON.txt lw=9999 "pft='./$PATH_SHELL/getIssuesInfo.bat $1 ',v1,' $ACRON $FILE_AUTHORS $INPUT_FOR_HISTORY_PROC'/" now >temp/avaliacao_lastIssues.bat
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
./$PATH_SHELL/getEdBoard.bat $1 $ACRON $OUTPUT_EDBOARD

echo $ACRON CORPO EDITORIAL >> $JournalFile
more $OUTPUT_EDBOARD >> $JournalFile


echo $ACRON AUTORES ARTIGOS >> $JournalFile
$MX "seq=$FILE_AUTHORS.seq¨" gizmo=$PATH_GZM/tab lw=9999  "pft=v1/"  now >> $JournalFile

echo $ACRON RECEBIDOS ACEITOS >> $JournalFile
$MX "seq=$INPUT_FOR_HISTORY_PROC.seq¨" gizmo=$PATH_GZM/tab lw=9999  "pft=v1/"  now >> $JournalFile
