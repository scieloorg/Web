CONFIG=$1
PID=$2
MFN=$3

. shs/readconfig.sh

if [ ! "@$MFN" == "@" ]
then
    if [ $MFN -gt 0 ]
    then
        $MX cipar=$CIPFILE QUERYLOG from=$MFN count=1 "proc='d*'" copy=QUERYLOG now -all
    fi
fi
