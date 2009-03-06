export BATCHES_PATH=procLangs/linux/
export PROCLANG_PATH=procLangs/

export SCILISTA=$1
export MX=$2
export BASESWORK=$3
export DBLANG=$4
export PROCLANG_LOG=$5
export DOCPATHS=$PROCLANG_PATH/config/docpaths.seq
export CIPARFILE=$PROCLANG_PATH/config/mycipar.cip

if [ ! -f $PROCLANG_PATH/config/docpaths.mst ]
then
	$MX seq=$DOCPATHS create=$PROCLANG_PATH/config/docpaths now -all
	echo created $PROCLANG_PATH/config/docpaths
fi

if [ ! -f $DBLANG.mst ] 
then

	$MX null count=0 create=$DBLANG now -all 
	$MX $DBLANG fst=@$PROCLANG_PATH/fst/lang.fst fullinv=$DBLANG
	echo created $DBLANG
fi

$MX seq=$SCILISTA lw=9999 "pft=if p(v1)  then '$BATCHES_PATH/deleteRecordsDBLang.bat ',v1/ fi" now> temp/procLangsDoForIssue.bat
chmod 775 temp/procLangsDoForIssue.bat
temp/procLangsDoForIssue.bat
$MX null count=0 create=$DBLANG now -all

$MX temp/procLangsDBLang append=$DBLANG now -all
$MX $DBLANG fst=@$PROCLANG_PATH/fst/lang.fst fullinv=$DBLANG


$MX seq=$SCILISTA lw=9999 "pft=if p(v1) then '$BATCHES_PATH/doForIssue.bat ',v1/ fi" now> temp/procLangsDoForIssue.bat
chmod 775 temp/procLangsDoForIssue.bat
temp/procLangsDoForIssue.bat

$MX $DBLANG fst=@$PROCLANG_PATH/fst/lang.fst fullinv=$DBLANG
