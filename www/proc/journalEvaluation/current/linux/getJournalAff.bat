# Executa getIssuesAff.bat para cada item em $3
# Param 1 arquivo com valores de variaveis
# Param 2 ACRON
# Param 3 SEQFILE

. $1

PROCESS_DATE=`date +%Y%m%d`
ACRON=$2
SEQFILE=$3
$MX "seq=$SEQFILE " lw=9999 "pft='./$PATH_CURRENT_SHELLS/getIssuesAff.bat $1 ',v1,' $ACRON ' /" now > temp/je_lastIssuesAff.bat
chmod 775 temp/je_lastIssuesAff.bat
./temp/je_lastIssuesAff.bat

