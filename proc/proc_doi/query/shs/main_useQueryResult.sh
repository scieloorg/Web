CONFIG=$1
RESULT=$2



. $CONFIG

if [ ! -d $TEMP_PATH ]
then
    echo create $TEMP_PATH
    mkdir -p $TEMP_PATH
fi

if [ ! -d $DATA_PATH ]
then
    echo create $DATA_PATH
    mkdir -p $DATA_PATH
fi

if [ ! -f $QUERYDB.mst ]
then
    $MX null count=1 "proc='a90{',date,'{'" append=$QUERYDB now -all
fi

$MX $QUERYDB fst=@fst/query.fst fullinv=$QUERYDB

sh ./reglog.sh $LOG_FILE "Process result $RESULT"
sh ./reglog.sh $LOG_FILE "check the actions"

echo > $TEMP_PATH/update.txt
$MX cipar=$CIPFILE seq=$RESULT "proc=@pft/add_doi_data.prc" lw=999 "proc='a8000{$CONFIG{a8001{$TEMP_PATH/update.txt{'" "pft=@pft/treatresult.pft" now | sort -u > $TEMP_PATH/treatresult.sh
sh ./reglog.sh $LOG_FILE "execute actions"
sh $TEMP_PATH/treatresult.sh

sh ./reglog.sh $LOG_FILE "generate update.sh"
$MX "seq=$TEMP_PATH/update.txt " lw=999 "pft=if size(v2)>0 then 'sh ./shs/updatereg.sh $CONFIG \"',replace(replace(v1,')','\)'),'(','\('),'\" ',v2,# fi" now > $TEMP_PATH/call_updatereg.sh
sh ./reglog.sh $LOG_FILE "execute update.sh"
sh $TEMP_PATH/call_updatereg.sh

sh ./reglog.sh $LOG_FILE "invert QUERY"
$MX $QUERYDB fst=@fst/query.fst fullinv=$QUERYDB
sh ./reglog.sh $LOG_FILE "invert QUERY"
$MX $QUERYLOGDB fst=@fst/log.fst fullinv=$QUERYLOGDB


echo $0 done.