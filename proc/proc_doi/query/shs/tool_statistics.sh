BATCH_LOGFILE=$1
BATCH_TEMP_PATH=$2
MSG=$3
. ./shs/readconfig.sh

t=`date '+%Y%m%d %H:%M:%S'`

sh ./reglog.sh $BATCH_LOGFILE "$QUERYDB"
#$MX $QUERYDB +control now>> $BATCH_LOGFILE
$MXTB $QUERYDB create=$BATCH_TEMP_PATH/numbers "100:'total_doi'/,if p(v237) then 'doi'/ fi,(if size(v880^*)=23 then 'pid_done'/,'pid_doc'/ fi,if size(v880^*)=28 then 'pid_done'/,'pid_ref'/ fi)" class=1000000
$MX $BATCH_TEMP_PATH/numbers "pft='|',v1,'|',v999,'|'/" now >> $BATCH_LOGFILE

$MX $BATCH_TEMP_PATH/numbers lw=999  "pft=@pft/stat01.pft" now > $BATCH_TEMP_PATH/numbers.prc

sh ./reglog.sh $BATCH_LOGFILE "$QUERYLOGDB"
#$MX $QUERYLOGDB +control now>> $BATCH_LOGFILE
$MXTB $QUERYLOGDB create=$BATCH_TEMP_PATH/numbers "100:'total_log'/,(if size(v880)=23 or size(v880)=28 then 'pid_toDo' fi/),if p(v100) then v100/ fi" class=1000000
$MX $BATCH_TEMP_PATH/numbers "pft='|',v1,'|',v999,'|'/" now >> $BATCH_LOGFILE
$MX $BATCH_TEMP_PATH/numbers lw=999 "pft=@pft/stat02.pft" now >> $BATCH_TEMP_PATH/numbers.prc

$MX null count=1 "proc='a5{$MSG{'" "proc=@$BATCH_TEMP_PATH/numbers.prc" append=$QUERYLOGDB.stat now -all


