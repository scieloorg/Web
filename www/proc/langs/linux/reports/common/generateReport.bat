. $1

EXPR=$2
RESULT_PATH=$3
FORMAT_ISSN=$4
FORMAT_YEAR=$5
FORMAT_DOCTOPIC=$6
RESULT_FILE_NAME=$7

echo Executing $0 $1 $2 $3 $4 $5 $6 $7 >> $PROCLANG_REPORT_LOG

$MX null count=1 "proc='d*a1{$FORMAT_ISSN{a2{$FORMAT_YEAR{a3{$FORMAT_DOCTOPIC{'" lw=9999 "pft=@$BATCHES_PATH/reports/common/format.pft" now > temp/langs_format.pft


$MX $DBLANGTAB btell=0 "bool=$EXPR"  lw=9999 "tab/width:1000=@temp/langs_format.pft" now > temp/langs_tab.txt

$MX seq=temp/langs_tab.txt lw=9999 "pft=@$BATCHES_PATH/reports/common/format2.pft" now | sort -u  > temp/langs_tab2.txt

$MX "seq=temp/langs_tab2.txt¨" gizmo=$GZM_TAB lw=9999  "pft=v1/" now  > $RESULT_PATH$RESULT_FILE_NAME.xls

$MX null count=1 "pft='<?xml version="1.0" encoding="iso-8859-1"?>'/,'<root>'/" now >  $RESULT_PATH$RESULT_FILE_NAME.xml
$MX seq=temp/langs_tab2.txt lw=9999 "pft='  <line>','<item>',v1,'</item>',|<item>|v2|</item>|,|<item>|v3|</item>|,|<item>|v4|</item>|,|<item>|v5|</item>|,,'</line>'"  now  >> $RESULT_PATH$RESULT_FILE_NAME.xml
$MX null count=1 "pft='</root>'/" now >>  $RESULT_PATH$RESULT_FILE_NAME.xml

