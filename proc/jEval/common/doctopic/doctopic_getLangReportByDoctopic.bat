. $1

DOCT=$2
RESULT_FILE_NAME=$3
SOURCE=$4

$MX null count=1 "pft='$DOCT'" gizmo=$GZM_DOCTOPIC now >> $RESULT_FILE_NAME
$MX seq=$TITLE_LANGS lw=9999 "pft=,'|',if l(['$SOURCE']'k=','$DOCT','-o-',v1)=0 then '0' else ref(['$SOURCE']l(['$SOURCE']'k=','$DOCT','-o-',v1),v5) fi" now >>  $RESULT_FILE_NAME
$MX seq=$TITLE_LANGS lw=9999 "pft=,'|',if l(['$SOURCE']'k=','$DOCT','-t-',v1)=0 then '0' else ref(['$SOURCE']l(['$SOURCE']'k=','$DOCT','-t-',v1),v5) fi" now >>  $RESULT_FILE_NAME
echo >> $RESULT_FILE_NAME