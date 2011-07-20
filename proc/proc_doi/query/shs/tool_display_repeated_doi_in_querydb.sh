
MX=../../cisis/mx
QUERYDB=../../../bases-work/doi/query
QUERYLOGDB=../../../bases-work/doi_query/querylog
TEMP=temp

mkdir temp

$MX $QUERYDB lw=999 "pft=(v237,'|doi|$QUERYDB|',mfn,/)"   now |sort > $TEMP/list_doi.txt
$MX seq=$TEMP/list_doi.txt create=$TEMP/list_doi now -all
$MX $TEMP/list_doi lw=999 "pft=@pft/tool_select_repeated_doi.pft" now > $TEMP/rem_repeated_doi.sh

echo Read $TEMP/rem_repeated_doi.sh