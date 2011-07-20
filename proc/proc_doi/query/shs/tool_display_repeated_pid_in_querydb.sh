
MX=../../cisis/mx
QUERYDB=../../../bases-work/doi/query
QUERYLOGDB=../../../bases-work/doi_query/querylog
TEMP=temp

mkdir temp

$MX $QUERYDB lw=999 "pft=(if v880<>'' then v880^*,'|doi|$QUERYDB|',mfn,/ fi)"   now |sort > $TEMP/list_pid_in_qdb.txt
$MX seq=$TEMP/list_pid_in_qdb.txt create=$TEMP/list_pid_in_qdb now -all
$MX $TEMP/list_pid_in_qdb lw=999 "pft=@pft/tool_select_repeated_pid_querydb.pft" now > $TEMP/rem_repeated_pid_in_qdb.sh


echo Read $TEMP/rem_repeated_pid_in_qdb.sh
