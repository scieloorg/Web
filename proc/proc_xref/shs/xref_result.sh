

. config.sh

PARAM_NEW_DB_DOI=$1
PARAM_STATUS=$2
PARAM_PID=$3
PARAM_DOI=$4

./reglog.sh $0 $1 $2 $3 $4

if [ "@$PARAM_STATUS" == "@new" ]
then
	if [ "@$PARAM_DOI" == "@" ]
	then 
	    echo $MX null count=1 lw=9999 "proc=if  '$PARAM_DOI'=''  then 'a880{$PARAM_PID{',|a881{|v881|{|,|a891{|v891|{|, 'a91{',date,'{a300{notfound{' fi" append=$PARAM_NEW_DB_DOI now -all
	    $MX null count=1 lw=9999 "proc=if  '$PARAM_DOI'=''  then 'a880{$PARAM_PID{',|a881{|v881|{|,|a891{|v891|{|,'a91{',date,'{a300{notfound{' fi" append=$PARAM_NEW_DB_DOI now -all
	else 
		echo $MX null count=1 lw=9999 "proc=if  '$PARAM_DOI'<>''  then 'a880{$PARAM_PID{',|a881{|v881|{|,|a891{|v891|{|,'a237{$PARAM_DOI{','a91{',date,'{a300{ok{' fi" append=$PARAM_NEW_DB_DOI now -all
	    $MX null count=1 lw=9999 "proc=if '$PARAM_DOI'<>''  then 'a880{$PARAM_PID{',|a881{|v881|{|,|a891{|v891|{|,'a237{$PARAM_DOI{','a91{',date,'{a300{ok{' fi" append=$PARAM_NEW_DB_DOI now -all
	fi
else
	if [ "@$PARAM_DOI" == "@" ]
	then 
	    echo $MX $PARAM_NEW_DB_DOI btell=0 "bool=pid=$PARAM_PID" lw=9999 "proc=if (v880='$PARAM_PID' or v881='$PARAM_PID' or v891='$PARAM_PID') and '$PARAM_DOI'=''  then 'd237d300d91a91{',date,'{a300{notfound{' fi" copy=$PARAM_NEW_DB_DOI now -all
	    $MX $PARAM_NEW_DB_DOI btell=0 "bool=pid=$PARAM_PID" lw=9999 "proc=if (v880='$PARAM_PID' or v881='$PARAM_PID' or v891='$PARAM_PID') and '$PARAM_DOI'=''  then 'd237d300d91a91{',date,'{a300{notfound{' fi" copy=$PARAM_NEW_DB_DOI now -all
	else 
		echo $MX $PARAM_NEW_DB_DOI btell=0 "bool=pid=$PARAM_PID" lw=9999 "proc=if (v880='$PARAM_PID' or v881='$PARAM_PID' or v891='$PARAM_PID') and '$PARAM_DOI'<>''  then 'd237d300d91a237{$PARAM_DOI{','a91{',date,'{a300{ok{' fi" copy=$PARAM_NEW_DB_DOI now -all
	    $MX $PARAM_NEW_DB_DOI btell=0 "bool=pid=$PARAM_PID" lw=9999 "proc=if (v880='$PARAM_PID' or v881='$PARAM_PID' or v891='$PARAM_PID') and '$PARAM_DOI'<>''  then 'd237d300d91a237{$PARAM_DOI{','a91{',date,'{a300{ok{' fi" copy=$PARAM_NEW_DB_DOI now -all
	fi
fi

