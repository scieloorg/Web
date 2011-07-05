
MX=../../cisis/mx
QUERYDB=../../../bases-work/doi/query
QUERYLOGDB=../../../bases-work/doi_query/querylog
TEMP=temp

mkdir temp

$MX $QUERYDB lw=999 "pft=(v237,'|doi|$QUERYDB|',mfn,/)"   now |sort > $TEMP/list_doi2.txt
$MX seq=$TEMP/list_doi2.txt create=$TEMP/list_doi2 now -all
$MX $TEMP/list_doi2 lw=999 "pft=@pft/tool_remove_doi2.pft" now > $TEMP/remove_doi2.sh



