CONFIG=$1
DOI=$2
PID=$3

. $CONFIG

$MX cipar=$CIPFILE QUERY btell=0 "bool=doi=$DOI" "proc='a880{$PID^d',date,'{'" copy=QUERY now -all



