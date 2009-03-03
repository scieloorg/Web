export BATCHES_PATH=scielo2lilacs/linux/
export MX=$MX
export WXIS=$WXIS

export SCIELOLILACS_LOG=$SCIELOLILACS_LOG

export ACRON=$1
export ISSUEID=$2
export FILENAME=$3
export EXTENSION=$4
export OLANG=$5
export LANGSEQ=$6
export DOCPATH=$7
export DOCFORMAT=$8

echo  Executing $0 for $ACRON $ISSUEID $FILENAME $DOCPATH >> $SCIELOLILACS_LOG

echo Files in $DOCPATH/$ACRON/$ISSUEID/ >> $SCIELOLILACS_LOG
ls $DOCPATH/$ACRON/$ISSUEID/  >> $SCIELOLILACS_LOG

$MX seq=$LANGSEQ lw=9999 "pft=if p(v1) then '$BATCHES_PATH/doForLang.bat $ACRON $ISSUEID $FILENAME $EXTENSION $OLANG ',v1,' $DOCPATH $DOCFORMAT'/ fi" now> temp/scielo2lilacs_DoForLang.bat

chmod 775 temp/scielo2lilacs_DoForLang.bat
temp/scielo2lilacs_DoForLang.bat
