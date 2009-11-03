. $1

RESULT=$2
EXPR=$3
FORMAT_ISSN=$4
FORMAT_YEAR=$5
FORMAT_DOCTOPIC=$6

$MX null count=1 "proc='a1{$FORMAT_ISSN{a2{$FORMAT_YEAR{a3{$FORMAT_DOCTOPIC{'" "pft=$BATCHES_PATH/reports/common/format.pft" now > temp/langs_format.pft
# TOTAL
$MX $DBLANGTAB btell=0 "bool=$EXPR" gizmo=$GZM_ISSN,1 gizmo=$GZM_DOCTOPIC,2 gizmo=$GZM_OT,3 gizmo=$GZM_LANG,4 "tab=@temp/langs_format.pft" now > temp/langs_tab.txt
$MX seq=temp/langs_tab.txt "pft=v3,"|"v4,"|"v5,"|"v6,"|"v7,"|"v8,"|"v9,,'|',v2/" now | sort -u  > temp/langs_tab2.txt
$MX seq=temp/langs_tab2.txt gizmo=$GZM_TAB now  > $RESULT.txt



#$CISIS_DIR/mxtb $DBLANGTAB create=$RESULT class=100000  100:"v1"
#$CISIS_DIR/mx $RESULT lw=9999 "pft=replace(s(v1,' ',v999),' ','|')/" now > $TMP_DIR/RESULT.txt
#echo Generating result $RESULT.txt
#$CISIS_DIR/mx  "seq=$TMP_DIR/RESULT.txt¨" gizmo=$TAB lw=9999  "pft=v1/"  now > $RESULT.txt