export BATCHES_PATH=procLangs/linux/

export MX=$MX
export LOGFILE=$PROCLANG_LOG
export DBLANG=$DBLANG

export ACRON=$1
export ISSUEID=$2
export FILENAME=$3
export EXTENSION=$4
export OLANG=$5
export LANGSEQ=$6
export PID=$7
export DB=$8

echo Executing $0 for $ACRON $ISSUEID $FILENAME >> $PROCLANG_LOG

$MX cipar=$CIPARFILE DOCPATHS lw=9999 "pft=if p(v1) then '$BATCHES_PATH/doForPath.bat $ACRON $ISSUEID $FILENAME $EXTENSION $OLANG $LANGSEQ ',v1,' ',v2/ fi" now> temp/procLangsDoForPath.bat

chmod 775 temp/procLangsDoForPath.bat

echo Creating the record >> $PROCLANG_LOG
$MX null count=0 create=temp/procLangsAddProc now -all
$MX $DB  btell=0  "D=$PID" "proc='d*','a880{$PID{a900{$ACRON$ISSUEID{a40{$OLANG{',('a83{',v83^l,'{'),'a91{',date,'{'" append=temp/procLangsAddProc now -all

echo Record created >> $PROCLANG_LOG
$MX temp/procLangsAddProc now >> $PROCLANG_LOG

echo Checking files >> $PROCLANG_LOG
temp/procLangsDoForPath.bat

echo Files checked >> $PROCLANG_LOG
$MX temp/procLangsAddProc now >> $PROCLANG_LOG

echo Append record to DBLAN >> $PROCLANG_LOG
$MX temp/procLangsAddProc count=1 append=$DBLANG now -all
echo >> $PROCLANG_LOG