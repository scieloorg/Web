. $1

echo Executing $0 $1 $2 $3 $4 $5  >> $PROCLANG_LOG

ACRON=$2
ISSUEID=$3


$MX $TEMP_DBLANG  btell=0  "IS=$ACRON$ISSUEID" "proc='d*'" copy=$TEMP_DBLANG now -all
echo Executed $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG

