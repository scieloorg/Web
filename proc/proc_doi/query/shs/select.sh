PID=$1
BATCH_LOGFILE=$2

. shs/readconfig.sh


# cria um shell script que
#   gerar? uma lista de novos pid para ingressar na base querylog
#   gerar? uma lista de pid existentes para atualizar na base querylog

sh ./reglog.sh $BATCH_LOGFILE  Generating $TEMP_PATH/sel.sh for $PID

echo ". ./shs/readconfig.sh"> $TEMP_PATH/sel.sh
$MX cipar=$CIPFILE ARTIGO btell=0 "R=$PID$ or hr=$PID$" "proc=@pft/get_data_from_query_and_log.prc"   lw=9999 "pft=@pft/selection.pft" now >> $TEMP_PATH/sel.sh

sh ./reglog.sh $BATCH_LOGFILE  Executing $TEMP_PATH/sel.sh for $PID
sh $TEMP_PATH/sel.sh
