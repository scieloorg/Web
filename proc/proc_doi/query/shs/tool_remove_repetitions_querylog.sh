
MX=../../cisis/mx
QUERYDB=../../../bases-work/doi/query
QUERYLOGDB=../../../bases-work/doi_query/querylog
TEMP=temp

mkdir temp

$MX $QUERYLOGDB lw=999 "pft=if v880<>'' then v880,'|log|$QUERYLOGDB|',mfn,/ fi" now |sort > $TEMP/list_log.txt


$MX seq=$TEMP/list_log.txt create=$TEMP/list_log now -all
$MX $TEMP/list_log lw=999 "pft=@pft/tool_remove_log.pft" now > $TEMP/remove_log.sh
