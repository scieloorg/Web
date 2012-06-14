

. config.sh
NEW_DB_DOI=$1

PID=$2
DOI=$3

./reglog.sh $0 $1 $2 $3

if [ "@$DOI" == "@" ]
then 
    echo $MX $NEW_DB_DOI btell=0 "bool=pid=$PID" lw=9999 "proc=if (v880='$PID' or v881='$PID' or v891='$PID') and '$DOI'=''  then 'd237d300d91a91{',date,'{a300{notfound{' fi" copy=$NEW_DB_DOI now -all
    $MX $NEW_DB_DOI btell=0 "bool=pid=$PID" lw=9999 "proc=if (v880='$PID' or v881='$PID' or v891='$PID') and '$DOI'=''  then 'd237d300d91a91{',date,'{a300{notfound{' fi" copy=$NEW_DB_DOI now -all
else 
	echo $MX $NEW_DB_DOI btell=0 "bool=pid=$PID" lw=9999 "proc=if (v880='$PID' or v881='$PID' or v891='$PID') and '$DOI'<>''  then 'd237d300d91a237{$DOI{','a91{',date,'{a300{ok{' fi" copy=$NEW_DB_DOI now -all
    $MX $NEW_DB_DOI btell=0 "bool=pid=$PID" lw=9999 "proc=if (v880='$PID' or v881='$PID' or v891='$PID') and '$DOI'<>''  then 'd237d300d91a237{$DOI{','a91{',date,'{a300{ok{' fi" copy=$NEW_DB_DOI now -all
fi
