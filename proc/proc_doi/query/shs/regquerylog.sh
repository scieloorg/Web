CONFIG=$1
PID=$2
STATUS=$3
. $CONFIG


$MX cipar=$CIPFILE QUERYLOG btell=0 "pid=$PID" "proc='d2','a2{$STATUS{a91{^d',date,'^s$STATUS{'" copy=QUERYLOG now -all


