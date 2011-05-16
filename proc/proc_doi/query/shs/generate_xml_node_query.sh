CONFIG=$1
PID=$2

. $CONFIG

$MX cipar=$CIPFILE ARTIGO btell=0 "hr=$PID or r=$PID" lw=9999 "pft=@pft/xml.pft" now


