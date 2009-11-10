. $1

ISSN=$2
F=temp/langs_TITLE_LANGS_$ISSN.seq

echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG

$MX $TITLE lw=9999 "pft='if [ -f temp/langs_TITLE_LANGS_',v400,'.seq ]'/,'then '/,'rm temp/langs_TITLE_LANGS_',v400,'.seq'/,'fi'/,('./$BATCHES_PATH/genDBLang/genLangsVsPathsAux.bat $1 ',v350,' temp/langs_TITLE_LANGS_',v400[1],'.seq',/)" now > temp/langs_genLangsVsPathsAux.bat
chmod 775 temp/langs_genLangsVsPathsAux.bat
./temp/langs_genLangsVsPathsAux.bat

echo      [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG