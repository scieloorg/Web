CONFIG=$1
PIDLIST=$2
YEAR=$3



if [ "@$CONFIG" == "@" ]
then
    echo Missing param 1 CONFIG
else
    if [ "@$PIDLIST" == "@" ]
    then
        echo Missing param 2 pidlist
    else
        if [ "@$YEAR" == "@" ]
        then
            echo Missing param 3 YEAR
        else
            . shs/readconfig.sh

            sh ./reglog.sh $LOG_FILE "Identifying articles published in $YEAR, and their references"
            echo >$PIDLIST
            $MX $ARTIGO btell=0 "bool=DTH=$YEAR$" "pft='sh ./shs/select.sh $CONFIG ',v880,' $PIDLIST' /"  now | sort -u > $TEMP_PATH/call_select.sh
            sh $TEMP_PATH/call_select.sh  > $PIDLIST
            sh ./reglog.sh $LOG_FILE "$PIDLIST generated."
            sh ./reglog.sh $LOG_FILE "$0 finished."


        fi
    fi
fi
