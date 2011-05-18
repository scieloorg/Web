CONFIG=$1
PID=$2


. $CONFIG

$MX cipar=$CIPFILE ARTIGO btell=0 "R=$PID$ or hr=$PID" lw=9999 "pft=if l(['QUERY']'pid='v880)=0 then v880/ fi" now





