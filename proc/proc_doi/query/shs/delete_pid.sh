CONFIG=$1
PID=$2

. $CONFIG

$MX cipar=$CIPFILE QUERY btell=0 "bool=pid=$PID" "proc='d880',(if v880='$PID'  then else 'a880{',v880,'{' fi)" copy=QUERY now -all



