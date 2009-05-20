# Param 1 issn
# Param 2 count

# export MX=$MX
# CPFILE
#
export MX=$3
export CPFILE=$4
export OUTPUT_PATH=$5
export ACRON=$6
export rel=$7
export PROCESS_DATE=`date +%Y%m%d`

export JOURNAL_OUTPUT_PATH=$OUTPUT_PATH/$ACRON/$PROCESS_DATE
mkdir -p $JOURNAL_OUTPUT_PATH

export EXCEL_FILE=$JOURNAL_OUTPUT_PATH/data_extracted_from_db.xml

$MX null count=1 lw=9999 "pft=@avaliacao/pft/data_extracted_from_db.xls.00.pft" now > $EXCEL_FILE

echo $ACRON Dados Basicos
#$MX cipar=$CPFILE TITLE btell=0 "loc=$1" lw=9999 gizmo=avaliacao/gizmo/gizmoFreq,340 "pft=@avaliacao/pft/data_extracted_from_db.xls.01.pft" now > $JOURNAL_OUTPUT_PATH/dados_basicos.xml
#more $JOURNAL_OUTPUT_PATH/dados_basicos.xml >> $EXCEL_FILE

#$MX null count=1 lw=9999 "pft=@avaliacao/pft/data_extracted_from_db.xls.02.pft" now >> $EXCEL_FILE
#$MX null count=1 lw=9999 "pft=@avaliacao/pft/data_extracted_from_db.xls.03.pft" now >> $EXCEL_FILE


#echo $ACRON Autores
#$MX cipar=$CPFILE ISSUE btell=0 "seq=$1$" lw=9999  "pft=if a(v131) and a(v132) and v32<>'ahead' and v32<>'review' and a(v41) then v35,v36*0.4,s(f(10000+val(v36*4),4,0))*1/ fi" now | sort -u -r > temp/avaliacao_lastIssues.seq
#$MX "seq=temp/avaliacao_lastIssues.seq " create=temp/avaliacao_lastIssues now -all
#$MX null count=0 create=$JOURNAL_OUTPUT_PATH/authors now
#$MX null count=0 create=$JOURNAL_OUTPUT_PATH/history now

#$MX temp/avaliacao_lastIssues count=$2 lw=9999 "pft='./avaliacao/permanencia/linux/getIssuesInfo.bat ',v1,' $ACRON $MX $CPFILE $EXCEL_FILE $JOURNAL_OUTPUT_PATH/authors $JOURNAL_OUTPUT_PATH/history'/" now >temp/avaliacao_lastIssues.bat
#chmod 775 temp/avaliacao_lastIssues.bat
#./temp/avaliacao_lastIssues.bat

$MX null count=1 lw=9999 "pft=@avaliacao/pft/data_extracted_from_db.xls.99.pft" now >> $EXCEL_FILE

echo $EXCEL_FILE
echo $rel