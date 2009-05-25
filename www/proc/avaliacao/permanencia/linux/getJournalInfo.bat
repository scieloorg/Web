# Param 1 issn
# Param 2 count

# MX=$MX
# CPFILE
#
PROCESS_DATE=`date +%Y%m%d%H%M%s`

MX=$3
CPFILE=$4
ACRON=$6

OUTPUT_PATH=$5
REL_OUTPUT_PATH=$7
HTML_FILE_OUTPUT=$8
JOURNAL_EDBOARD_HTML_PATH=$9
J_DIR=$ACRON
JournalFileName=journaldata.txt
AVALLOG=log/avaliacao_permanencia.log
JOURNAL_OUTPUT_PATH=$OUTPUT_PATH/$J_DIR/


JournalFile=$OUTPUT_PATH/$J_DIR/$JournalFileName
JOURNAL_LINK=$REL_OUTPUT_PATH/$J_DIR/$JournalFileName

if [ -d $OUTPUT_PATH/$ACRON ]
then 
	rm -rf $JOURNAL_OUTPUT_PATH
fi
mkdir -p $JOURNAL_OUTPUT_PATH

echo journal ...
echo $ACRON
$MX cipar=$CPFILE TITLE btell=0 "loc=$1" lw=9999 "pft='<p><a href=\"$J_DIR/$JournalFileName\">',v100,'</a></p>'" now >> $HTML_FILE_OUTPUT

./avaliacao/permanencia/linux/WriteLog.bat $AVALLOG $ACRON Basic data
$MX cipar=$CPFILE TITLE btell=0 "loc=$1" lw=9999 gizmo=avaliacao/gizmo/gizmoFreq,340 "pft=@avaliacao/pft/journal.pft" now > $JOURNAL_OUTPUT_PATH/dados_basicos.seq


./avaliacao/permanencia/linux/WriteLog.bat $AVALLOG $ACRON Authors History Afiliations
$MX cipar=$CPFILE ISSUE btell=0 "seq=$1$" lw=9999  "pft=if a(v131) and a(v132) and v32<>'ahead' and v32<>'review' and a(v41) then v35,v36*0.4,s(f(10000+val(v36*4),4,0))*1/ fi" now | sort -u -r > temp/avaliacao_lastIssues.seq
$MX "seq=temp/avaliacao_lastIssues.seq " create=temp/avaliacao_lastIssues now -all

#rm $JOURNAL_OUTPUT_PATH/authors.*
#rm $JOURNAL_OUTPUT_PATH/history.*

$MX temp/avaliacao_lastIssues count=$2 lw=9999 "pft='./avaliacao/permanencia/linux/getIssuesInfo.bat ',v1,' $ACRON $MX $CPFILE $JOURNAL_OUTPUT_PATH/authors $JOURNAL_OUTPUT_PATH/history $AVALLOG'/" now >temp/avaliacao_lastIssues.bat
chmod 775 temp/avaliacao_lastIssues.bat
./temp/avaliacao_lastIssues.bat


echo $ACRON $PROCESS_DATE >> $JournalFile


echo $ACRON DADOS BASICOS >> $JournalFile
# echo avaliacao/gizmo/tab
$MX "seq=$JOURNAL_OUTPUT_PATH/dados_basicos.seq¨" gizmo=avaliacao/gizmo/tab lw=9999 "pft=v1/"  now >> $JournalFile

./avaliacao/permanencia/linux/getEdBoard.bat $MX $CPFILE $JOURNAL_EDBOARD_HTML_PATH $ACRON $OUTPUT_PATH $REL_OUTPUT_PATH $JournalFile

echo $ACRON AUTORES ARTIGOS >> $JournalFile
$MX "seq=$JOURNAL_OUTPUT_PATH/authors.seq¨" gizmo=avaliacao/gizmo/tab lw=9999  "pft=v1/"  now >> $JournalFile

echo $ACRON RECEBIDOS ACEITOS >> $JournalFile
$MX "seq=$INPUT_FOR_HISTORY_PROC.seq¨" gizmo=avaliacao/gizmo/tab lw=9999  "pft=v1/"  now >> $JournalFile
