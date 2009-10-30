. $1

echo Executing $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG

ISSUE_PID=$2

$MX cipar=$FILE_CIPAR ARTIGO lw=9999 btell=0 hr=$ISSUE_PID$ "pft=#,'$BATCHES_PATH/doForArticle.bat $1 ',mfn" now> temp/langs_DoForArticle.bat
chmod 775 temp/langs_DoForArticle.bat
./temp/langs_DoForArticle.bat

echo Executed $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG