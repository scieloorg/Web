
MX=../../cisis/mx
QUERYDB=../../../bases-work/doi/query
QUERYLOGDB=../../../bases-work/doi_query/querylog
TEMP=temp

mkdir temp

$MX $QUERYLOGDB "pft=if p(v880) then v880,'|l|',mfn/ fi" now> $TEMP/list.txt
$MX $QUERYDB "pft=(if v880<>'' then v880^*,'|q|',mfn/ fi)"   now >> $TEMP/list.txt
cat $TEMP/list.txt | sort > $TEMP/list_sort.txt
$MX seq=$TEMP/list_sort.txt create=$TEMP/list now -all


$MX $TEMP/list lw=999 "proc='a4{$QUERYLOGDB{'" "pft=@pft/tool_select_repeated_pid_in_both.pft" now > $TEMP/rem_repeated_pid_in_both.sh
$MX $TEMP/list lw=999 "pft=if ref(mfn+1,v1)=v1 and ref(mfn+1,v2)=v2 then v1,'|',v2,'|',v3/ fi" now > $TEMP/mesmo_pid_doi_diferentes.txt

echo Read $TEMP/mesmo_pid_doi_diferentes.txt
echo Read $TEMP/rem_repeated_pid_in_both.sh