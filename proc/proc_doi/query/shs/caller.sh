CONFIG=$1
#OPTIONAL
PIDLIST=$2



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

if [ ! -f $QUERYDB.mst ]
then
    $MX null count=1 "proc='a90{',date,'{'" append=$QUERYDB now -all
    $MX $QUERYDB fst=@fst/query.fst fullinv=$QUERYDB
fi

RESULT=$DATA_PATH/`date '+%Y%m%d%H%M'`.res

sh ./reglog.sh $LOG_FILE inicio
# dado um pid de title, or issue or article, seleciona os pid das referencias e do artigo

sh ./reglog.sh $LOG_FILE selection
if [ -f $PIDLIST ]
then
    $MX seq=$PIDLIST lw=999 "pft=if v1<>'' then 'sh ./shs/select.sh $CONFIG ',if v1*0.1<>'S' then 'S' fi,v1,# fi" now > $TEMP_PATH/call_select.sh
else
    $MX cipar=$CIPFILE ARTIGO btell=0 "hr=s$ or r=s$" lw=999  "pft='sh ./shs/select.sh $CONFIG ',v880,#" now > $TEMP_PATH/call_select.sh
fi


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

sh ./reglog.sh $LOG_FILE "process result"
sh ./reglog.sh $LOG_FILE "check the actions"
echo $MX cipar=$CIPFILE seq=$RESULT "proc=if p(v9) or p(v11) then 'a9999{^d',if p(v11) then v12,'^p',v11,'^tm' else v10,'^p',v9,'^tj' fi,'{' fi" lw=999 "pft=if v9999^d='' then 'sh ./shs/regnotfound.sh $CONFIG ',v9999^p,# else if l(['QUERY']v9999^d)=0 then 'sh ./shs/createreg.sh $CONFIG ',v9999^d,' ',v9999^t,# else 'echo ',v9999^d,' ',v9999^p,'>> $TEMP_PATH/update.txt',# fi, fi" now

$MX cipar=$CIPFILE seq=$RESULT "proc=if p(v9) or p(v11) then 'a9999{^d',if p(v11) then v12,'^p',v11,'^tm' else v10,'^p',v9,'^tj' fi,'{' fi" lw=999 "pft=if v9999^d='' then 'sh ./shs/regnotfound.sh $CONFIG ',v9999^p,# else if l(['QUERY']v9999^d)=0 then 'sh ./shs/createreg.sh $CONFIG ',v9999^d,' ',v9999^t,# else 'echo ',v9999^d,' ',v9999^p,'>> $TEMP_PATH/update.txt',# fi, fi" now | sort -u > $TEMP_PATH/treatresult.sh
sh ./reglog.sh $LOG_FILE "execute actions"
sh $TEMP_PATH/treatresult.sh

sh ./reglog.sh $LOG_FILE "invert QUERY"
$MX cipar=$CIPFILE QUERY fst=@fst/query.fst fullinv=QUERY

sh ./reglog.sh $LOG_FILE "generate update.sh"
$MX seq=$TEMP_PATH/update.txt lw=999 "pft='sh ./shs/updatereg.sh $CONFIG ',v1,#" now > $TEMP_PATH/call_updatereg.sh
sh ./reglog.sh $LOG_FILE "execute update.sh"
sh $TEMP_PATH/call_updatereg.sh

