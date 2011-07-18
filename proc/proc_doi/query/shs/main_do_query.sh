CONFIG=$1
RESULT=$2
STATUS=$3

if [ "@$CONFIG" == "@" ]
then
    echo MISSING CONFIG
else
    if [ "@$RESULT" == "@" ]
    then
        echo MISSING RESULT
    else
        . shs/readconfig.sh

        BATCH_ID=`date '+%Y%m%d%H%M'`
        BATCH_LOGFILE=$LOG_PATH/p2.log
        BATCH_TEMP_PATH=$TEMP_PATH/q.$BATCH_ID
        PID_SELECTED_LIST=$BATCH_TEMP_PATH/selection.txt

        mkdir -p $BATCH_TEMP_PATH

        sh ./reglog.sh $BATCH_LOGFILE inicio

        STATUSAPP=`cat $APP_STFILE`
        if [ "@$STATUSAPP" == "@nothing" ]
        then
            echo querying > $APP_STFILE

            STATUSQL=`cat $QLOG_STFILE`
            if [ ! "$STATUSQL" == "free" ]
            then
                sh ./reglog.sh $BATCH_LOGFILE  invert $QUERYLOGDB
                $MX $QUERYLOGDB fst=@fst/log.fst fullinv=$QUERYLOGDB
                sh ./reglog.sh $BATCH_LOGFILE  fim invert $QUERYLOGDB
                echo free> $QLOG_STFILE
            fi

            if [ "$STATUS" == "new" ]
            then
                sh ./reglog.sh $BATCH_LOGFILE find NEW status
                $MX $QUERYLOGDB btell=0 "cst=$STATUS" "proc='d100a100{query{a91{^query^d',date,'{'" copy=$QUERYLOGDB now -all

                echo inverting> $QLOG_STFILE
                sh ./reglog.sh $BATCH_LOGFILE  invert $QUERYLOGDB
                $MX $QUERYLOGDB fst=@fst/log.fst fullinv=$QUERYLOGDB
                sh ./reglog.sh $BATCH_LOGFILE  fim invert $QUERYLOGDB
                echo free> $QLOG_STFILE
            fi
            if [ "$STATUS" == "notfound" ]
            then
                sh ./reglog.sh $BATCH_LOGFILE find NEW status
                $MX $QUERYLOGDB btell=0 "cst=$STATUS" "proc='d100a100{query{a91{^query^d',date,'{'" copy=$QUERYLOGDB now -all

                echo inverting> $QLOG_STFILE
                sh ./reglog.sh $BATCH_LOGFILE  invert $QUERYLOGDB
                $MX $QUERYLOGDB fst=@fst/log.fst fullinv=$QUERYLOGDB
                sh ./reglog.sh $BATCH_LOGFILE  fim invert $QUERYLOGDB
                echo free> $QLOG_STFILE
            fi
            $MX $QUERYLOGDB btell=0 "cst=query" "pft=v880,' ',v691/" now > $PID_SELECTED_LIST

            sh ./reglog.sh $BATCH_LOGFILE "create $BATCH_TEMP_PATH/selection"
            echo >>$PID_SELECTED_LIST
            $MX "seq=$PID_SELECTED_LIST " create=$BATCH_TEMP_PATH/selection now -all
            echo nothing > $APP_STFILE
        else
            echo main_do_query canceled
            echo executing $STATUSAPP
        fi
        if [ -f "$PID_SELECTED_LIST" ]
        then

            C=0`wc -l $PID_SELECTED_LIST`
            $MX null count=1 "proc='a9999{',mid('$C',1,instr('$C',' ')-1),'{'" "pft=v9999" now > $BATCH_TEMP_PATH/c

            QTDPID=`cat $BATCH_TEMP_PATH/c`
            echo $QTDPID
            START=1
            while [ $START -lt $QTDPID ]
            do
                sh ./reglog.sh $BATCH_LOGFILE "generate xml"
                XML=$BATCH_TEMP_PATH/selection_$START.xml
                $MX null count=1 "proc='a9000{$EMAIL{a9001{',replace(date,' ','-'),'{'"  lw=999 "pft=@pft/begin.pft" now > $XML

                sh ./reglog.sh $BATCH_LOGFILE "execute selection $START $QTDPID"
                $MX $BATCH_TEMP_PATH/selection from=$START count=$MAX_QTY_DOC_PER_XML lw=999 "pft='sh ./shs/generate_xml_node_query.sh $CONFIG ',v1,' $XML ',v2,#" now >$BATCH_TEMP_PATH/call_generate_xml_node_query_and_do_log.sh
                sh $BATCH_TEMP_PATH/call_generate_xml_node_query_and_do_log.sh
                $MX null count=1 lw=999 "pft=@pft/end.pft" now >> $XML

                sh ./reglog.sh $BATCH_LOGFILE "execute request"
                cd $JAR_PATH
                sh ../reglog.sh $BATCH_LOGFILE  "sh ./CrossRefQuery.sh -f $XML -t d -a live -u $USERNAME -p $PASSWORD -r piped"
                sh ./CrossRefQuery.sh -f $XML -t d -a live -u $USERNAME -p $PASSWORD -r piped >> $RESULT

                #cd $DOUPLOAD_PATH
                #sh ../reglog.sh $BATCH_LOGFILE  "java -jar "doUpload.jar" -u $USERNAME -p $PASSWORD -f file-name
                #java -jar doUpload.jar -u $USERNAME -p $PASSWORD -f $XML

                cd ..
                sh ./reglog.sh $BATCH_LOGFILE "receive result"


                #QTDPID=`expr $QTDPID - $MAX_QTY_DOC_PER_XML`
                START=`expr $START + $MAX_QTY_DOC_PER_XML`

            done
            sh ./reglog.sh $BATCH_LOGFILE $RESULT generated.
        else
            echo Missing pid list to query $PID_SELECTED_LIST
        fi
        
        rm -rf $BATCH_TEMP_PATH/
    fi
    
fi

