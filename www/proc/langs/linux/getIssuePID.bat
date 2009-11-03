. $1

echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG
#langs/linux//getIssuePID.bat langs//config/config.inc temp/langs_new_scilista.txt rsp v40n1
nScilista=$2
ACRON=$3
ISSUEID=$4

$MX $TITLE btell=0 "bool=sgl=$ACRON" count=1 "pft=v400" now > temp/langs_v400
ISSN=`cat temp/langs_v400`

$MX cipar=$FILE_CIPAR ARTIGO btell=0 "bool=HR=S$ISSN$" "text=\\$ACRON\\$ISSUEID\\"  "pft=v880*0.18/" now | sort -u >> $nScilista

echo      [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG

