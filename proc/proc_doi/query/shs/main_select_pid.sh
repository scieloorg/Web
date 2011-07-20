CONFIG=$1
PIDLIST=$2
COLLECTION=$3



if [ "@$CONFIG" == "@" ]
then
    echo MISSING CONFIG
else
    if [ "@$PIDLIST" == "@" ]
    then
        echo MISSING PIDLIST
    else
        if [ "@$COLLECTION" == "@" ]
        then
            echo MISSING COLLECTION
        else
            if [ ! -f $PIDLIST ]
            then
                echo Missing pid list $PIDLIST
            else


                . shs/readconfig.sh

                STATUSAPP=`cat $APP_STFILE`

                if [ "@$STATUSAPP" == "@nothing" ]
                then
                    echo selecting > $APP_STFILE

                    BATCH_ID=`date '+%Y%m%d%H%M'`
                    BATCH_LOGFILE=$LOG_PATH/p1.log
                    BATCH_TEMP_PATH=$TEMP_PATH/s.$BATCH_ID

                    mkdir -p $BATCH_TEMP_PATH/
                    sh ./reglog.sh $BATCH_LOGFILE inicio

                    STATUSQL=`cat $QLOG_STFILE`
                    if [ ! "$STATUSQL" == "free" ]
                    then
                        sh ./reglog.sh $BATCH_LOGFILE  invert $QUERYLOGDB
                        $MX $QUERYLOGDB fst=@fst/log.fst fullinv=$QUERYLOGDB
                        sh ./reglog.sh $BATCH_LOGFILE  fim invert $QUERYLOGDB
                        echo free> $QLOG_STFILE
                    fi

                    STATUSQ=`cat $Q_STFILE`
                    if [ ! "$STATUSQ" == "free" ]
                    then
                        sh ./reglog.sh $BATCH_LOGFILE  invert $QUERYDB
                        $MX $QUERYDB fst=@fst/query.fst fullinv=$QUERYDB
                        sh ./reglog.sh $BATCH_LOGFILE  fim invert $QUERYDB
                        echo free> $Q_STFILE
                    fi
                    tar cvfzp $WORK_PATH/before.select.tgz $QUERYDB.* $QUERYLOGDB.*

                    sh ./reglog.sh $BATCH_LOGFILE "Statistics BEFORE"
                    sh ./shs/tool_statistics.sh $BATCH_LOGFILE $BATCH_TEMP_PATH "before selection"

                    sh ./reglog.sh $BATCH_LOGFILE list of pid or acron issue_id

                    echo >> $PIDLIST
                    $MX "seq=$PIDLIST " lw=9999 "pft=if size(v1)>0 then 'sh shs/find_pid.sh ',v1,' ',v2,# fi" now >>$BATCH_TEMP_PATH/find_pid.sh
                    sh $BATCH_TEMP_PATH/find_pid.sh > $PIDLIST


                    sh ./reglog.sh $BATCH_LOGFILE "generate $BATCH_TEMP_PATH/call_select.sh"
                    echo >> $PIDLIST
                    $MX seq=$PIDLIST lw=9999 "pft=if size(v1)>0 then 'sh shs/select.sh ',if v1*0.1<>'S' then 'S' fi,v1,' $BATCH_LOGFILE $COLLECTION',# fi" now | sort -u -r>>$BATCH_TEMP_PATH/call_select.sh

                    sh ./reglog.sh $BATCH_LOGFILE "execute $BATCH_TEMP_PATH/call_select.sh"
                    sh ./reglog.sh $BATCH_LOGFILE "... it will append new PID to querylog"

                    echo writing> $QLOG_STFILE
                    sh $BATCH_TEMP_PATH/call_select.sh

                    echo inverting> $QLOG_STFILE
                    sh ./reglog.sh $BATCH_LOGFILE  invert $QUERYLOGDB
                    $MX $QUERYLOGDB fst=@fst/log.fst fullinv=$QUERYLOGDB
                    sh ./reglog.sh $BATCH_LOGFILE  fim invert $QUERYLOGDB
                    echo free> $QLOG_STFILE

                    sh ./reglog.sh $BATCH_LOGFILE "Statistics AFTER"
                    sh ./shs/tool_statistics.sh $BATCH_LOGFILE $BATCH_TEMP_PATH "after selection"


                    echo nothing > $APP_STFILE
                    rm -rf $BATCH_TEMP_PATH/
                    sh ./reglog.sh $BATCH_LOGFILE $0 done

                else
                    echo Nothing executed
                    echo status=$STATUSAPP
                fi
            fi
        fi
    fi
fi

