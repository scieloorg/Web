CONFIG=$1
PID=$2
STATUS=$3
MFN=$4

. shs/readconfig.sh

if [ "@$MFN" == "@" ]
then
    $MX cipar=$CIPFILE null count=1 "proc='a880{$PID{','a100{$STATUS{','a91{^s$STATUS^d',date,'{'" append=QUERYLOG now -all
else
    if [ $MFN -gt 0 ]
    then
        $MX cipar=$CIPFILE QUERYLOG from=$MFN count=1 "proc='d100','a100{$STATUS{','a91{^s$STATUS^d',date,'{'" copy=QUERYLOG now -all
    else
        #$MX cipar=$CIPFILE null count=1 "proc='a880{$PID{','a100{$STATUS{','a91{^s$STATUS^d',date,'{'" append=QUERYLOG now -all
    fi
fi
