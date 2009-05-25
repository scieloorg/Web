ISSUEPID=$1
ACRON=$2
MX=$3
CPFILE=$4
AFFSEQ=$5
AVALLOG=$6


./avaliacao/permanencia/linux/WriteLog.bat $AVALLOG $2 $1  Affiliations list
$MX cipar=$CPFILE ARTIGO btell=0 "HR=S$1$" lw=9999 "pft=if p(v70) then (v880[1],'|'v70,'|',v70^*,',,',v70^c,',',v70^s,',',v70^p/) fi" now >> $AFFSEQ

