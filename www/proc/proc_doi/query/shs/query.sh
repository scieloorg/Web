CONFIG=$1
PID=$2
XML=$3
RESULT=$4

. $CONFIG

$MX null count=1 lw=999 "proc='a9000{$EMAIL{a9001{',replace(date,' ','-'),'{'" "pft=@pft/begin.pft" now > $XML
$MX cipar=$CIPAR ARTIGO btell=0 "R=$PID$" lw=9999 "pft=@pft/xml.pft" now >> $XML
$MX null count=1 lw=999 "pft=@pft/end.pft" now >> $XML

cd crossref
crossrefquery -f $XML -t d -a live -u bireme -p p@s5w0Rd -r piped >> $RESULT
cd ..

#$MX cipar=$CIPAR seq=$XML.seq "pft='./shs/treat_result.sh ',if p(v11) then 'm ',v11,' ',if v12<>'' then f(l(['QUERY']v12),1,0),' ',v12 fi else 'j ',v9,' ',if v10<>'' then f(l(['QUERY']v10),1,0),' ',v10 fi fi,#" now > $XML.sh
#sh $XML.sh

