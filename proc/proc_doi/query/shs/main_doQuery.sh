CONFIG=$1
#OPTIONAL
PIDLIST=$2
RESULT=$3


. $CONFIG

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
    $MX seq=$PIDLIST "proc=if v1<>'' then 'a9000{',if v1*0.1<>'S' then 'S' fi,v1,'{' fi" lw=999 "pft=if v9000<>'' then 'sh ./shs/select.sh $CONFIG ',v9000,#  fi" now > $TEMP_PATH/call_select.sh

    sh $TEMP_PATH/call_select.sh | sort -u > $TEMP_PATH/selection.txt

    # para cada MAX itens da selecao, fazer um request de query
    sh ./reglog.sh $LOG_FILE "split selection"
    $MX seq=$TEMP_PATH/selection.txt create=$TEMP_PATH/selection now -all

    C=0`wc -l $TEMP_PATH/selection.txt`
    $MX null count=1 "proc='a9999{',mid('$C',1,instr('$C',' ')-1),'{'" "pft=v9999" now > $TEMP_PATH/c

    COUNTY=`cat $TEMP_PATH/c`
    echo $COUNTY
    START=1
    while [ $COUNTY -gt 0 ]
    do
        sh ./reglog.sh $LOG_FILE "execute selection $START $COUNTY"
        $MX $TEMP_PATH/selection from=$START count=$MAX_QTY_DOC_PER_XML lw=999 "pft='sh ./shs/generate_xml_node_query.sh $CONFIG ',v1,#" now >$TEMP_PATH/call_generate_xml_node_query.sh

        sh ./reglog.sh $LOG_FILE "generate xml"
        XML=$TEMP_PATH/selection_$START.xml
        $MX null count=1 lw=999 "proc='a9000{$EMAIL{a9001{',replace(date,' ','-'),'{'" "pft=@pft/begin.pft" now > $XML
        sh $TEMP_PATH/call_generate_xml_node_query.sh >> $XML
        $MX null count=1 lw=999 "pft=@pft/end.pft" now >> $XML

        sh ./reglog.sh $LOG_FILE "execute request"
        cd $JAR_PATH
        sh ../reglog.sh $LOG_FILE  "sh ./CrossRefQuery.sh -f $XML -t d -a live -u $USERNAME -p $PASSWORD -r piped"
        sh ./CrossRefQuery.sh -f $XML -t d -a live -u $USERNAME -p $PASSWORD -r piped >> $RESULT
        cd ..
        sh ./reglog.sh $LOG_FILE "receive result"


        COUNTY=`expr $COUNTY - $MAX_QTY_DOC_PER_XML`
        START=`expr $START + $MAX_QTY_DOC_PER_XML`
    done

    sh ./reglog.sh $LOG_FILE $RESULT generated.
fi
sh ./reglog.sh $LOG_FILE $0 finished.
