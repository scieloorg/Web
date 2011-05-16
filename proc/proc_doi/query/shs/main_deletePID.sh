CONFIG=$1
PIDLIST=$2
RESULT=$3


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

sh ./reglog.sh $LOG_FILE inicio

sh ./reglog.sh $LOG_FILE deleting
if [ ! -f $PIDLIST ]
then
    echo Missing pid list $PIDLIST
else
    $MX seq=$PIDLIST "proc=if v1<>'' then 'a9000{',if v1*0.1<>'S' then 'S' fi,v1,'{' fi" lw=999 "pft=if v9000<>'' then 'sh ./shs/delete_pid.sh $CONFIG ',v9000,#  fi" now > $TEMP_PATH/call_delete_pid.sh

    sh $TEMP_PATH/delete_pid_select.sh 
    
fi
sh ./reglog.sh $0 finished.
