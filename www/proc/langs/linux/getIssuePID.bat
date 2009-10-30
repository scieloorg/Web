. $1

echo Executing $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG

nScilista=$2
ACRON=$3
ISSUEID=$4

DBACRON=$BASESWORK/$ACRON/$ACRON

$MX $DBACRON lw=9999 h=$ISSUEID count=1 "pft='S',v35,v36*0.4, s(f(10000+val(v36*4),1,0))*1,/" now >> $nScilista

echo Executed $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG

