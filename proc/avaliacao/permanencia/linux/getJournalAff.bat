# Param 1 issn
# Param 2 count

# MX=$MX
# CPFILE
#
PROCESS_DATE=`date +%Y%m%d`

MX=$3
CPFILE=$4
AFFSEQ=$5
ACRON=$6

AVALLOG=log/avaliacao_permanencia.log



echo journal ...
echo $ACRON

./avaliacao/permanencia/linux/WriteLog.bat $AVALLOG $ACRON Affiliations
$MX cipar=$CPFILE ISSUE btell=0 "seq=$1$" lw=9999  "pft=if a(v131) and a(v132) and v32<>'ahead' and v32<>'review' and a(v41) then v35,v36*0.4,s(f(10000+val(v36*4),4,0))*1/ fi" now | sort -u -r > temp/avaliacao_lastIssues.seq
$MX "seq=temp/avaliacao_lastIssues.seq " create=temp/avaliacao_lastIssues now -all

$MX temp/avaliacao_lastIssues count=$2 lw=9999 "pft='./avaliacao/permanencia/linux/getIssuesAff.bat ',v1,' $ACRON $MX $CPFILE $AFFSEQ $AVALLOG'/" now >temp/avaliacao_lastIssuesAff.bat
chmod 775 temp/avaliacao_lastIssuesAff.bat
./temp/avaliacao_lastIssuesAff.bat

