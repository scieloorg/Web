REP=$1

. ./shs/readconfig.sh

if [ "@" == "@$REP" ]
then
    REP=$QUERYLOGDB.stat.csv
fi



$MX $QUERYLOGDB.stat lw=999 "pft=@pft/evolution.pft" now > $REP