. config.sh

TIPO=$1
C_PID=$2
MFN=$3
DOI=$4


if [ "@$DOI" == "@" ]
then
    $MX cipar=$CIPAR null count=1 "proc='a2{$TIPO{a880{$C_PID^d',date,'{'" append=NOTFOUND now -all
else
    if [ "@$MFN" == "@0" ]
    then
        # create reg
        $MX cipar=$CIPAR null count=1 "proc='a237{$DOI{a2{$TIPO{a880{$C_PID^d',date,'{'" append=QUERY now -all
    else
        # update reg
        $MX cipar=$CIPAR QUERY from=$MFN count=1 "proc='a880{$C_PID^d',date,'{'" copy=QUERY now -all
    fi
fi