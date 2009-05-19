export BATCHES_PATH=procLangs/linux/
export MX=$MX
export PROCLANG_LOG=$PROCLANG_LOG

export ACRON=$1
export ISSUEID=$2
export FILENAME=$3
export EXTENSION=$4
export OLANG=$5
export LANGSEQ=$6
export DOCPATH=$7
export DOCFORMAT=$8

echo  Executing $0 for $ACRON $ISSUEID $FILENAME $DOCPATH >> $PROCLANG_LOG

echo Files in $DOCPATH/$ACRON/$ISSUEID/ >> $PROCLANG_LOG
ls $DOCPATH/$ACRON/$ISSUEID/  >> $PROCLANG_LOG

$MX seq=$LANGSEQ lw=9999 "pft=if p(v1) then '$BATCHES_PATH/doForLang.bat $ACRON $ISSUEID $FILENAME $EXTENSION $OLANG ',v1,' $DOCPATH $DOCFORMAT'/ fi" now> temp/procLangsDoForLang.bat

chmod 775 temp/procLangsDoForLang.bat
temp/procLangsDoForLang.bat
