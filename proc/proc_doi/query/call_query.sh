dos2unix *.sh
dos2unix */*.sh


        . shs/readconfig.sh

        echo ARTIGO.*=$ARTIGO.*     >  $CIPFILE
        echo QUERY.*=$QUERYDB.*       >> $CIPFILE
        echo QUERYLOG.*=$QUERYLOGDB.* >> $CIPFILE


        if [ ! -d $RESULT_PATH ]
        then
            mkdir -p $RESULT_PATH
        fi

        RES=$RESULT_PATH/`date '+%Y%m%d%H%M'`.res

        sh ./shs/main_do_query.sh config.sh $RES

