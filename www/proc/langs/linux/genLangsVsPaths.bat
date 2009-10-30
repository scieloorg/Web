. $1

echo Executing $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG

$MX $TITLE "pft=(v350/)" now | sort -u > $PROCLANG_PATH/tables/langs_title.seq

if [ -f $PROCLANG_PATH/tables/lang_paths.seq ]
then
    rm $PROCLANG_PATH/tables/lang_paths.seq
fi
$MX seq=$PROCLANG_PATH/tables/langs_title.seq "pft='./$BATCHES_PATH/genLangsVsPathsAux.bat $1 ',v1/" now > temp/langs_genLangPath.bat
chmod 775 temp/langs_genLangPath.bat
./temp/langs_genLangPath.bat

echo Executed $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG