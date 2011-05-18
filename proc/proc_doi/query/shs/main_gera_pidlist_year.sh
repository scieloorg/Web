CONFIG=$1
#OPTIONAL
PIDLIST=$2
YEAR=$3



if [ "@$CONFIG" == "@" ]
then
    echo Missing param 1 CONFIG
else
    . $CONFIG
    if [ "@$PIDLIST" == "@" ]
    then
        echo Missing param 2 pidlist
    else
        if [ "@$YEAR" == "@" ]
        then
            echo Missing param 3 YEAR
        else
            sh ./reglog.sh $LOG_FILE "Identifying articles published in $YEAR, and their references"
            $MX $ARTIGO btell=0 "bool=DTH=$YEAR$" "pft='sh ./shs/select.sh $CONFIG ',v880/"  now | sort -u > $TEMP_PATH/call_select.sh
            sh $TEMP_PATH/call_select.sh  > $PIDLIST
            sh ./reglog.sh $LOG_FILE "$PIDLIST generated."
            sh ./reglog.sh $LOG_FILE "$0 finished."


        fi
    fi
fi
