CONFIG=$1
RESULT=$2


if [ "@$CONFIG" == "@" ]
then
    echo missing CONFIG
else
    if [ "@$RESULT" == "@" ]
    then
        echo missing RESULT
    else
        
        . ./shs/readconfig.sh
        STATUSAPP=`cat $APP_STFILE`
        BATCH_ID=`date '+%Y%m%d%H%M'`
        BATCH_LOGFILE=$LOG_PATH/p3.log
        BATCH_TEMP_PATH=$TEMP_PATH/r.$BATCH_ID

        if [ "@$STATUSAPP" == "@nothing" ]
        then
            echo manage_result > $APP_STFILE

            
            mkdir -p $BATCH_TEMP_PATH/

            . ./shs/readconfig.sh

            echo >$BATCH_LOGFILE
            sh ./reglog.sh $BATCH_LOGFILE inicio

            STATUSQL=`cat $QLOG_STFILE`
            if [ ! "$STATUSQL" == "free" ]
            then
                sh ./reglog.sh $BATCH_LOGFILE  invert $QUERYLOGDB
                $MX $QUERYLOGDB fst=@fst/log.fst fullinv=$QUERYLOGDB
                sh ./reglog.sh $BATCH_LOGFILE  fim invert $QUERYLOGDB
                echo free> $QLOG_STFILE
            fi

            STATUSQ=`cat $Q_STFILE`
            if [ ! -f $QUERYDB.mst ]
            then
                $MX null count=1 "proc='a91{',date,'{'" create=$QUERYDB now -all
                $MX $QUERYDB fst=@fst/query.fst fullinv=$QUERYDB
            fi
            if [ ! "$STATUSQ" == "free" ]
            then
                sh ./reglog.sh $BATCH_LOGFILE  invert $QUERYDB
                $MX $QUERYDB fst=@fst/query.fst fullinv=$QUERYDB
                sh ./reglog.sh $BATCH_LOGFILE  fim invert $QUERYDB
                echo free> $Q_STFILE
            fi
            sh ./reglog.sh $BATCH_LOGFILE "backup"
            tar cvfzp $WORK_PATH/before.result.tgz $QUERYDB.* $QUERYLOGDB.*

            sh ./reglog.sh $BATCH_LOGFILE "Statistics BEFORE"
            sh ./shs/tool_statistics.sh $BATCH_LOGFILE $BATCH_TEMP_PATH "before treating result"

            sh ./reglog.sh $BATCH_LOGFILE "Sort result"
            echo reading> $Q_STFILE
            echo >> $RESULT
            $MX cipar=$CIPFILE seq=$RESULT lw=99999 "pft=@pft/sort_result.pft" now |sort -u > $BATCH_TEMP_PATH/sorted_result.txt
            echo >>$BATCH_TEMP_PATH/sorted_result.txt
            $MX seq=$BATCH_TEMP_PATH/sorted_result.txt create=$BATCH_TEMP_PATH/sorted_result now -all

            #1 doi, 2 pid, 3 tipo
            sh ./reglog.sh $BATCH_LOGFILE "Join same doi"
            $MX cipar=$CIPFILE  $BATCH_TEMP_PATH/sorted_result lw=999999 "pft=if v1='' then #,'k1|',v2,'|',v4 else if  v1<>ref(mfn-1,v1) then #,f(l(['QUERY']'doi=',v1),1,0),'|',v1,'|',v3,'|', fi,if l(['QUERY']'pidcol=',v2,v4)=0 then 'a880{'v2,'^c',v4,'^d',s(date)*0.15,'{' fi,  fi" now> $BATCH_TEMP_PATH/doi_agrouped.seq
            
            sh ./reglog.sh $BATCH_LOGFILE "Generate gen_instructions.sh"
            echo ". ./shs/readconfig.sh"> $BATCH_TEMP_PATH/gen_instructions.sh
            $MX cipar=$CIPFILE  mfrl=60000 fmtl=60000  seq=$BATCH_TEMP_PATH/doi_agrouped.seq lw=999999 "pft=@pft/generate_instructions.pft" now >> $BATCH_TEMP_PATH/gen_instructions.sh
            

            sh ./reglog.sh $BATCH_LOGFILE "Execute $BATCH_TEMP_PATH/gen_instructions.sh"
            sh $BATCH_TEMP_PATH/gen_instructions.sh
            sh ./reglog.sh $BATCH_LOGFILE "Fim $BATCH_TEMP_PATH/gen_instructions.sh"

            sh ./reglog.sh $BATCH_LOGFILE "Retira registros vazios de querylog"
            $MX cipar=$CIPFILE null count=0 create=$QUERYLOGDB.bkp now -all
            $MX cipar=$CIPFILE $QUERYLOGDB append=$QUERYLOGDB.bkp now -all
            $MX cipar=$CIPFILE $QUERYLOGDB.bkp create=$QUERYLOGDB now -all

            sh ./reglog.sh $BATCH_LOGFILE "Fim Retira registros vazios de querylog"

            echo inverting> $Q_STFILE
            sh ./reglog.sh $BATCH_LOGFILE  invert $QUERYDB
            $MX $QUERYDB fst=@fst/query.fst fullinv=$QUERYDB
            sh ./reglog.sh $BATCH_LOGFILE  fim invert $QUERYDB
            echo free> $Q_STFILE

            echo inverting> $QLOG_STFILE
            sh ./reglog.sh $BATCH_LOGFILE  invert $QUERYLOGDB
            $MX $QUERYLOGDB fst=@fst/log.fst fullinv=$QUERYLOGDB
            sh ./reglog.sh $BATCH_LOGFILE  fim invert $QUERYLOGDB
            echo free> $QLOG_STFILE


            sh ./reglog.sh $BATCH_LOGFILE "Statistics AFTER"
            sh ./shs/tool_statistics.sh $BATCH_LOGFILE $BATCH_TEMP_PATH "after treating result"


            #rm -rf $BATCH_TEMP_PATH/
            echo nothing> $APP_STFILE

            sh ./reglog.sh $BATCH_LOGFILE "$0 done"
        else
             sh ./reglog.sh $BATCH_LOGFILE $0 canceled
             sh ./reglog.sh $BATCH_LOGFILE Executing $STATUSAPP

        fi
        
    fi
fi
