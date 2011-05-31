CONFIG=$1
PID=$2

. shs/readconfig.sh


# cria um shell script que
#   gerar? uma lista de novos pid para ingressar na base querylog
#   gerar? uma lista de pid existentes para atualizar na base querylog
$MX cipar=$CIPFILE ARTIGO btell=0 "R=$PID$ or hr=$PID$" "proc=@pft/get_data_from_query_and_log.prc"   lw=9999 "pft=@pft/selection.pft" now
