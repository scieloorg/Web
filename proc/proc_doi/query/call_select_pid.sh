dos2unix *.sh
dos2unix */*.sh

PIDLIST=$1


if [ "@" == "@$PIDLIST" ]
then
    echo Missing pidlist which contains PID or partial PID
else
    if [ -f $PIDLIST ]
    then

        . shs/readconfig.sh

        echo ARTIGO.*=$ARTIGO.*     >  $CIPFILE
        echo QUERY.*=$QUERYDB.*     >> $CIPFILE
        echo QUERYLOG.*=$QUERYLOGDB.*     >> $CIPFILE
        
        sh ./shs/main_select_pid.sh config.sh $PIDLIST
    else
        echo Missing $PIDLIST
    fi
    
fi
