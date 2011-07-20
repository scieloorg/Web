CONFIG=$1
PIDLIST=$2

if [ "@$CONFIG" == "@" ]
then
    echo Missing param 1 CONFIG
else
    if [ "@$PIDLIST" == "@" ]
    then
        echo Missing param 2 pidlist
    else

        . shs/readconfig.sh

        if [ ! -d $TEMP_PATH ]
        then
            echo create $TEMP_PATH
            mkdir -p $TEMP_PATH
        fi

        if [ ! -d $WORK_PATH ]
        then
            echo create $WORK_PATH
            mkdir -p $WORK_PATH
        fi

        sh ./reglog.sh $LOG_FILE inicio

        sh ./reglog.sh $LOG_FILE deleting
        if [ ! -f $PIDLIST ]
        then
            echo Missing pid list $PIDLIST
        else
            echo >> $PIDLIST
            $MX seq=$PIDLIST "proc=if v1<>'' then 'a9000{',if v1*0.1<>'S' then 'S' fi,v1,'{' fi" lw=999 "pft=if v9000<>'' then 'sh ./shs/delete_pid.sh $CONFIG ',v9000,#  fi" now > $TEMP_PATH/call_delete_pid.sh

            sh $TEMP_PATH/delete_pid_select.sh
            $MX $QUERYDB fst=@fst/query.fst fullinv=$QUERYDB
            sh ./reglog.sh $LOG_FILE $0 finished.
        fi
        
    fi
fi