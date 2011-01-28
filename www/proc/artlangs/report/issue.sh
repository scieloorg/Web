MX=$1
CIPFILE=$2
TEMP_PATH=$3
EXPR=$4
OUTPUT=$5

echo inicio issue.sh $SUBJ $EXPR `date`
$MX cipar=$CIPFILE ARTIGO btell=0 "bool=$EXPR" gizmo=report/lowercase "pft=if (p(v83) or v32='review') and p(v40) then v880,'|',v40/,ref(['LANG']l(['LANG']'hr='v880),if p(v601) then (v880[1],'|',v601^l/) fi) fi" now | sort -u >> $OUTPUT
echo fim issue.sh $SUBJ $EXPR `date`