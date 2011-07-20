CONFIG=$1



if [ "@$CONFIG" == "@" ]
then
    echo MISSING CONFIG
else
    dos2unix *.sh shs/*.sh
    . shs/readconfig.sh
    if [ ! -d $WORK_PATH ]
    then
        sh ./reglog.sh $LOG_FILE  create $WORK_PATH
        mkdir -p $WORK_PATH
    fi
    if [ ! -f $QLOG_STFILE ]
    then
        echo free>$QLOG_STFILE
    fi
    if [ ! -f $Q_STFILE ]
    then
        echo free>$Q_STFILE
    fi
    if [ ! -d $TEMP_PATH ]
    then
        sh ./reglog.sh $LOG_FILE create $TEMP_PATH
        mkdir -p $TEMP_PATH
    fi

    sh ./reglog.sh $LOG_FILE  create shs/ent e shs/ent2
    dos2unix shs/ent.seq
    $MX seq=shs/ent.seq create=shs/ent now -all
    dos2unix shs/ent2.seq
    $MX seq=shs/ent2.seq create=shs/ent2 now -all

    if [ ! -f $QUERYLOGDB.mst ]
    then
        sh ./reglog.sh $LOG_FILE  create $QUERYLOGDB
        $MX null count=1 "proc='a1{',date,'{'" create=$QUERYLOGDB now -all
        echo invert> $QLOG_STFILE
    fi
    if [ ! -f $QUERYDB.mst ]
    then
        sh ./reglog.sh $LOG_FILE  create $QUERYDB
        $MX null count=1 "proc='a1{',date,'{'" create=$QUERYDB now -all
        echo invert> $Q_STFILE
    fi

    STATUSQ=`cat $Q_STFILE`
    STATUSQL=`cat $QLOG_STFILE`
    if [ "$STATUSQL" == "invert" ]
    then
        echo inverting> $QLOG_STFILE
        sh ./reglog.sh $LOG_FILE  invert $QUERYLOGDB
        $MX $QUERYLOGDB fst=@fst/log.fst fullinv=$QUERYLOGDB
        sh ./reglog.sh $LOG_FILE  fim invert $QUERYLOGDB
        echo free> $QLOG_STFILE
    fi
    if [ "$STATUSQ" == "invert" ]
    then
        echo inverting> $Q_STFILE
        sh ./reglog.sh $LOG_FILE  invert $QUERYDB
        $MX $QUERYDB fst=@fst/query.fst fullinv=$QUERYDB
        sh ./reglog.sh $LOG_FILE  fim invert $QUERYDB
        echo free> $Q_STFILE
    fi
    sh ./reglog.sh $LOG_FILE $0 finished.
fi

