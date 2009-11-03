. $1

echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG

FILENAME_NOEXT=$2
DIR_ACRON_ISSUE=$3
OLANG=$4
procFile=$5

#more $PROCLANG_PATH/tables/lang_paths.seq

$MX cipar=$FILE_CIPAR seq=$PROCLANG_PATH/tables/lang_paths.seq lw=9999 "pft='./$BATCHES_PATH/get601or602.bat $1 ',v1,' $PATH_FILES/',v2,' ',v3,' ',v4,' $FILENAME_NOEXT $DIR_ACRON_ISSUE $OLANG $procFile'/" now > temp/langs_testFiles.bat


chmod 775 temp/langs_testFiles.bat
./temp/langs_testFiles.bat


echo      [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG