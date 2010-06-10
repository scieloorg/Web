. $1

echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG
#langs/linux//getIssuePID.bat langs//config/config.inc temp/langs_new_scilista.txt rsp v40n1
nScilista=$2
ACRON=$3
ISSUEID=$4
YEAR=$5

if [ "@$ISSUEID" == "@x" ]
then
    if [ "@$YEAR" == "@" ]
    then
        $MX $TITLE btell=0 "text=mpu,'$ACRON',mpl" count=1 "pft=if v68='$ACRON' or v930='$ACRON' then v400/ fi" now >> $nScilista
    else
        $MX cipar=$FILE_CIPAR ARTIGO btell=0 "tp=i" "pft=if v930=s(mpu,'$ACRON',mpl) and v65*0.4='$YEAR' then 'S',v35,'$YEAR',# fi," now | sort -u >> $nScilista
    fi
else
    $MX $TITLE btell=0 "text=mpu,'$ACRON',mpl" count=1 "pft=if v68='$ACRON' or v930='$ACRON' then v400 fi" now > temp/langs_v400
    ISSN=`cat temp/langs_v400`

    $MX cipar=$FILE_CIPAR ARTIGO btell=0 "bool=HR=S$ISSN$" "text=\\$ACRON\\$ISSUEID\\"  "pft=v880*0.18/" now | sort -u >> $nScilista
fi
echo      [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG

