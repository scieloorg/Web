
export ACRON=$1
export ISSUEID=$2

if [ ! -f temp/procLangsDBLang.mst ]
then
	$MX null count=0 create=temp/procLangsDBLang now -all
	
fi

$MX $DBLANG  btell=0  "IS=$ACRON$ISSUEID" "proc='d*'" copy=temp/procLangsDBLang now -all
$MX null count=0 create=$DBLANG now -all

$MX temp/procLangsDBLang append=$DBLANG now -all
$MX $DBLANG fst=@$PROCLANG_PATH/fst/lang.fst fullinv=$DBLANG

