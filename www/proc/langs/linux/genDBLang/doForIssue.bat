. $1


echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG

ISSUE_PID=$2

echo `date '+%Y.%m.%d %H:%M:%S'` Executing $ISSUE_PID
$MX cipar=$FILE_CIPAR ARTIGO lw=9999 btell=0 hr=$ISSUE_PID$ "pft=#,'$BATCHES_PATH/genDBLang/doForArticle.bat $1 ',mfn" now> temp/langs_DoForArticle.bat
chmod 775 temp/langs_DoForArticle.bat
./temp/langs_DoForArticle.bat
echo `date '+%Y.%m.%d %H:%M:%S'` Executed $ISSUE_PID
echo      [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG