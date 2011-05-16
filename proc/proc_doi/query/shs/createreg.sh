CONFIG=$1
DOI=$2
TIPO=$3

. $CONFIG

$MX cipar=$CIPFILE null count=1 "proc='a237{$DOI{a2{$TIPO{'" append=QUERY now -all



