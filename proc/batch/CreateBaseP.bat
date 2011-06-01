ID=$1
MX=$2
DB=$3
NEWDBPATH=$4
NEWDB=$5
if [ ! -d $NEWDBPATH ]
then
    mkdir -p $NEWDBPATH
fi
$MX $DB btell=0 "bool='P$ID'" create=$NEWDBPATH/$NEWDB now -all
$MX $DB btell=0 "bool='P$ID'" "proc='d.'" copy=$DB now -all
