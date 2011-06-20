. config.sh



CIPFILE=$TEMP_PATH/query.cip
LOG_FILE=$LOG_PATH/doi_query.log
QUERYLOGDB=$WORK_PATH/querylog
RESULT_PATH=$WORK_PATH/results
PROCESSED_PATH=$WORK_PATH/processed
INPROC_PATH=$WORK_PATH/inproc

QLOG_STFILE=$LOG_PATH/qlog
Q_STFILE=$LOG_PATH/q
APP_STFILE=$LOG_PATH/status

if [ ! -d $LOG_PATH ]
then
    mkdir -p $LOG_PATH
fi

if [ ! -f $Q_STFILE ]
then
    echo free> $Q_STFILE
fi
if [ ! -f $QLOG_STFILE ]
then
    echo free> $QLOG_STFILE
fi
if [ ! -f $APP_STFILE ]
then
    echo nothing> $APP_STFILE
fi


echo ARTIGO.*=$ARTIGO.*     >  $CIPFILE
        echo ISSUE.*=$ISSUEDB.*     >> $CIPFILE
        echo TITLE.*=$TITLEDB.*     >> $CIPFILE
        echo QUERY.*=$QUERYDB.*     >> $CIPFILE
        echo QUERYLOG.*=$QUERYLOGDB.*     >> $CIPFILE