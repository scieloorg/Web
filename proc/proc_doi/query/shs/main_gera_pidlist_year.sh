CONFIG=$1
#OPTIONAL
PIDLIST=$2
YEAR=$3


. $CONFIG

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
            
            $MX $ARTIGO btell=0 "bool=DHT=$YEAR$" "pft=v880/"  now | sort -u > $PIDLIST.tmp
            echo >> $PIDLIST.tmp

            $MX seq=$PIDLIST.tmp lw=9999 "pft=if size(v1)>0 then 'sh ./shs/select.sh $CONFIG ',v1/ fi"  now > $TEMP_PATH/call_select.sh
            sh $TEMP_PATH/call_select.sh | sort -u > $PIDLIST


        fi
    fi
fi
sh ./reglog.sh $LOG_FILE $PIDLIST generated.
sh ./reglog.sh $LOG_FILE $0 finished.
