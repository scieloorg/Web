CONFIG=$1
PIDLIST=$2
PIDSELLIST=$3
STATUS=$4


if [ "@$CONFIG" == "@" ]
then
    echo Missing param 1 CONFIG
else
    . shs/readconfig.sh

    if [ "@$PIDLIST" == "@" ]
    then
        echo Missing param 2 pidlist
    else

        if [ "@$PIDSELLIST" == "@" ]
        then
            echo Missing param 3 PIDSELLIST
        else

            if [ "@$STATUS" == "@" ]
            then
                echo Missing param 4 STATUS
            else

                $MX $QUERYLOGDB btell=0 "bool=CST=$STATUS" "pft=v880/" now  | sort -u > $PIDSELLIST
                sh ./reglog.sh $LOG_FILE $PIDSELLIST generated.
                sh ./reglog.sh $LOG_FILE $0 finished.

            fi

        fi

    fi
fi
