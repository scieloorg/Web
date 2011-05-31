BATCH_LOGFILE=$1
BATCH_TEMP_PATH=$2
. ./shs/readconfig.sh

sh ./reglog.sh $BATCH_LOGFILE "$QUERYDB"
$MX $QUERYDB +control now>> $BATCH_LOGFILE
$MXTB $QUERYDB create=$BATCH_TEMP_PATH/numbers "100:(if v880<>'' then 'pid' fi/),if p(v237) then 'doi'/ fi" class=1000000
$MX $BATCH_TEMP_PATH/numbers "pft='|',v1,'|',v999,'|'/" now >> $BATCH_LOGFILE

sh ./reglog.sh $BATCH_LOGFILE "$QUERYLOGDB"
$MX $QUERYLOGDB +control now>> $BATCH_LOGFILE
$MXTB $QUERYLOGDB create=$BATCH_TEMP_PATH/numbers "100:(if v880<>'' then 'pid' fi/),if p(v100) then v100/ fi" class=1000000
$MX $BATCH_TEMP_PATH/numbers "pft='|',v1,'|',v999,'|'/" now >> $BATCH_LOGFILE
