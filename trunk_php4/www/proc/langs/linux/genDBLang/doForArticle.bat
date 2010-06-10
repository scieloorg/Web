. $1
MFN=$2
DBLANGMFN=$3
ISSN=$4
FILE_PATHS_AND_LANGS=temp/langs_TITLE_LANGS_$ISSN.seq

echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5    >> $PROCLANG_LOG

echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

echo Create Proc
$MX cipar=$FILE_CIPAR ARTIGO from=$MFN count=1 lw=99999 "pft=@$BATCHES_PATH/genDBLang/doForArticlePft01.pft" now > temp/langs_proc.prc

echo Create temp/langs_get601and602.bat and call
# v4000 = nome do arquivo
# v4001 = acron_issue_id
# v4002 = ext original
$MX cipar=$FILE_CIPAR ARTIGO from=$MFN count=1 "proc=@$BATCHES_PATH/genDBLang/doForArticlePft02.prc" lw=99999 "pft='./$BATCHES_PATH/genDBLang/get601and602.bat $1 \"',v4000,'\" ',v4001,' ',v40,' temp/langs_proc.prc ',v4002,' $FILE_PATHS_AND_LANGS'/" now > temp/langs_get601and602.bat
chmod 775 temp/langs_get601and602.bat
./temp/langs_get601and602.bat 

echo Create/Update record
if [ "@$DBLANGMFN" == "@0" ]
then
    $MX cipar=$FILE_CIPAR ARTIGO from=$MFN count=1 "proc=@temp/langs_proc.prc" append=$DBLANG now -all
else
    $MX cipar=$FILE_CIPAR $DBLANG from=$DBLANGMFN count=1 "proc=@temp/langs_proc.prc" copy=$DBLANG now -all
fi
echo      [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG