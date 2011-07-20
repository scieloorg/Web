dos2unix *.sh
dos2unix */*.sh

PIDLIST=$1
COLLECTION=$2

if [ "@" == "@$PIDLIST" ]
then
    echo Missing pidlist which contains PID or partial PID
else
    if [ -f $PIDLIST ]
    then

        if [ "@" == "@$COLLECTION" ]
        then
            echo Missing COLLECTION
        else
            . shs/readconfig.sh
        
            sh ./shs/main_select_pid.sh config.sh $PIDLIST $COLLECTION
            
        fi
    else
        echo Missing $PIDLIST
    fi
    
fi
