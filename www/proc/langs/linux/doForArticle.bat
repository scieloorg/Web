. $1
MFN=$2

echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5    >> $PROCLANG_LOG

#echo `date '+%Y.%m.%d %H:%M:%S'` Executing article
$MX cipar=$FILE_CIPAR ARTIGO from=$MFN count=1 "pft=@$BATCHES_PATH/doForArticlePft01.pft" now > temp/langs_proc.prc
$MX cipar=$FILE_CIPAR ARTIGO from=$MFN count=1 "proc=@$BATCHES_PATH/doForArticlePft02.prc" lw=99999 "pft=if size(v4001)>0 then './$BATCHES_PATH/get601and602.bat $1 ',v4000,' ',v4001,' ',v40,' temp/langs_proc.prc'/ fi" now > temp/langs_get601and602.bat
chmod 775 temp/langs_get601and602.bat

#echo `date '+%Y.%m.%d %H:%M:%S'` Executing article testing
./temp/langs_get601and602.bat 
#echo `date '+%Y.%m.%d %H:%M:%S'` Executed article testing
#$MX cipar=$FILE_CIPAR ARTIGO from=$MFN count=1 "proc=@temp/langs_proc.prc" append=$DBLANG now -all

$MX cipar=$FILE_CIPAR ARTIGO from=$MFN count=1 "pft=v880" now > temp/langs_PID
PID=`cat temp/langs_PID`
$MX $DBLANG btell=0 bool=$PID "pft=mfn" now > temp/langs_mfn
DBLANGMFN=`cat temp/langs_mfn`

if [ "@$DBLANGMFN" == "@" ]
then
    $MX cipar=$FILE_CIPAR ARTIGO from=$MFN count=1 "proc=@temp/langs_proc.prc" append=$DBLANG now -all
else
    $MX cipar=$FILE_CIPAR $DBLANG from=$DBLANGMFN count=1 "proc=@temp/langs_proc.prc" copy=$DBLANG now -all
fi


#echo `date '+%Y.%m.%d %H:%M:%S'` Executed article
echo      [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG