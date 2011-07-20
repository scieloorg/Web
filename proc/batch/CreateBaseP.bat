ID=$1
MX=$2
DB=$3
NEWDBPATH=$4
NEWDB=$5
if [ ! -d $NEWDBPATH ]
then
    mkdir -p $NEWDBPATH
fi

$MX $DB btell=0 "bool=RP$ID" count=1 "pft=mfn,'|',v701/" now > i.txt
$MX $DB btell=0 "bool=RP$ID" "pft=mfn,'|',v701/" now | sort -r >> i.txt
$MX seq=i.txt count=2 create=$NEWDBPATH/$NEWDB now -all

$MX $DB btell=0 "bool=P$ID" append=$NEWDBPATH/$NEWDB now -all
$MX $DB btell=0 "bool=P$ID" "proc='d*'" copy=$DB now -all

echo $NEWDBPATH/$NEWDB >> log/NUMEROS
$CISIS_DIR/mx $NEWDBPATH/$NEWDB +control now >> log/NUMEROS

