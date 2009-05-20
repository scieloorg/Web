export MX=$1
export CONTENT=$2
export OUTPUT_HTML=$3

$MX null count=1 "pft='<html><body>','<a href="$4">$2</a><br/>','<table>'" now > $OUTPUT_HTML

$MX "seq=$CONTENT	" "pft=@avaliacao/pft/html.pft" now >> $OUTPUT_HTML

$MX null count=1 "pft='</table></body></html>'" now >> $OUTPUT_HTML
