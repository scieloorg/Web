
MX=../../cisis/mx
QUERYDB=../../../bases-work/doi/query
QUERYLOGDB=../../../bases-work/doi_query/querylog
TEMP=temp

mkdir temp

$MX $QUERYDB lw=999 "pft=(if v880<>'' then v880^*,'|doi|$QUERYDB|',mfn,/ fi)"   now |sort > $TEMP/list_doi.txt
$MX seq=$TEMP/list_doi.txt create=$TEMP/list_doi now -all
$MX $TEMP/list_doi lw=999 "pft=@pft/tool_remove_doi.pft" now > $TEMP/remove_doi.sh
