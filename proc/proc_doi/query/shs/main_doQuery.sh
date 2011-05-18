CONFIG=$1
#OPTIONAL
PIDLIST=$2
RESULT=$3


. $CONFIG

LOC_TEMP_PATH=$TEMP_PATH/`date '+%Y%m%d%H%M'`

if [ ! -d $TEMP_PATH ]
then
    echo create $TEMP_PATH
    mkdir -p $TEMP_PATH
fi

if [ ! -d $DATA_PATH ]
then
    echo create $DATA_PATH
    mkdir -p $DATA_PATH
fi
dos2unix shs/ent.seq
$MX seq=shs/ent.seq create=shs/ent now -all

sh ./reglog.sh $LOG_FILE inicio
# dado um pid de title, or issue or article, seleciona os pid das referencias e do artigo

sh ./reglog.sh $LOG_FILE selection
if [ ! -f $PIDLIST ]
then
    echo Missing pid list $PIDLIST
else

    # para cada MAX itens da selecao, fazer um request de query
    sh ./reglog.sh $LOG_FILE "split selection"
    $MX seq=$PIDLIST create=$TEMP_PATH/selection now -all

    if [ ! -f $QUERYLOGDB.mst ]
    then
        $MX $TEMP_PATH/selection create=$QUERYLOGDB now -all
        $MX $QUERYLOGDB fst=@fst/log.fst fullinv=$QUERYLOGDB
    else
        $MX $QUERYLOGDB fst=@fst/log.fst fullinv=$QUERYLOGDB
        $MX $TEMP_PATH/selection "proc=if l(['$QUERYLOGDB']'pid='v1)>0 then 'd*' fi" append=$QUERYLOGDB now -all
        $MX $QUERYLOGDB fst=@fst/log.fst fullinv=$QUERYLOGDB
    fi

    C=0`wc -l $PIDLIST`
    $MX null count=1 "proc='a9999{',mid('$C',1,instr('$C',' ')-1),'{'" "pft=v9999" now > $TEMP_PATH/c

    COUNTY=`cat $TEMP_PATH/c`
    echo $COUNTY
    START=1
    while [ $START -lt $COUNTY ]
    do
        sh ./reglog.sh $LOG_FILE "generate xml"
        XML=$TEMP_PATH/selection_$START.xml
        $MX null count=1 lw=999 "proc='a9000{$EMAIL{a9001{',replace(date,' ','-'),'{'" "pft=@pft/begin.pft" now > $XML

        sh ./reglog.sh $LOG_FILE "execute selection $START $COUNTY"
        $MX $TEMP_PATH/selection from=$START count=$MAX_QTY_DOC_PER_XML lw=999 "pft=if size(v1)=23 or size(v1)=28 then 'sh ./shs/generate_xml_node_query.sh $CONFIG ',v1,' $XML '#,'sh ./shs/regquerylog.sh $CONFIG ',v1,' query '# fi" now >$TEMP_PATH/call_generate_xml_node_query_and_do_log.sh
        sh $TEMP_PATH/call_generate_xml_node_query_and_do_log.sh
        $MX null count=1 lw=999 "pft=@pft/end.pft" now >> $XML

        sh ./reglog.sh $LOG_FILE "execute request"
        cd $JAR_PATH
        sh ../reglog.sh $LOG_FILE  "sh ./CrossRefQuery.sh -f $XML -t d -a live -u $USERNAME -p $PASSWORD -r piped"
        sh ./CrossRefQuery.sh -f $XML -t d -a live -u $USERNAME -p $PASSWORD -r piped >> $RESULT
        cd ..
        sh ./reglog.sh $LOG_FILE "receive result"


        #COUNTY=`expr $COUNTY - $MAX_QTY_DOC_PER_XML`
        START=`expr $START + $MAX_QTY_DOC_PER_XML`
    done
    $MX $QUERYLOGDB fst=@fst/log.fst fullinv=$QUERYLOGDB

    sh ./reglog.sh $LOG_FILE $RESULT generated.
fi
sh ./reglog.sh $LOG_FILE $0 finished.
