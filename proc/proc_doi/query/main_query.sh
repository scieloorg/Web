dos2unix *.sh
dos2unix */*.sh

PIDLIST=$1
if [ "@" == "@$PIDLIST" ]
then
    echo Missing pidlist
else
    if [ -f $PIDLIST ]
    then

        . config.sh

        echo ARTIGO.*=$ARTIGO.*     >  $CIPFILE
        echo QUERY.*=$QUERYDB.*     >> $CIPFILE
        echo QUERYLOG.*=$QUERYLOGDB.*     >> $CIPFILE
        echo NOTFOUND.*=$NOTFOUND.* >> $CIPFILE


        if [ ! -d $RESULT_PATH ]
        then
            mkdir -p $RESULT_PATH
        fi

        RES=$RESULT_PATH/`date '+%Y%m%d%H%M'`.res

        sh ./shs/main_doQuery.sh config.sh $PIDLIST $RES
    else
        echo Missing $PIDLIST
    fi
    
fi