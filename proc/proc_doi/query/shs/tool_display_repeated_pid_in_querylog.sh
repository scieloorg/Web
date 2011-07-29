
MX=../../cisis/mx
QUERYDB=../../../bases-work/doi/query
QUERYLOGDB=../../../bases-work/doi_query/querylog
TEMP=temp

mkdir temp

$MX $QUERYLOGDB lw=999 "pft=if v880<>'' then v880,'|log|$QUERYLOGDB|',mfn,/ fi" now |sort > $TEMP/list_pid_in_log.txt


$MX seq=$TEMP/list_pid_in_log.txt create=$TEMP/list_pid_in_log now -all
$MX $TEMP/list_pid_in_log lw=999 "pft=@pft/tool_select_repeated_pid_log.pft" now > $TEMP/rem_repeated_pid_in_log.sh

echo Read $TEMP/rem_repeated_pid_in_log.sh
