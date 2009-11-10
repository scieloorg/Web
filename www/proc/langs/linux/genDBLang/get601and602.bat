. $1

echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5 $6 $7  >> $PROCLANG_LOG

FILENAME_NOEXT=$2
DIR_ACRON_ISSUE=$3
OLANG=$4
procFile=$5
OEXT=$6
FILE_PATH_AND_LANG=$7

echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5 $6 $7
if [ ! -f $FILE_PATH_AND_LANG ]
then
    echo Missing $FILE_PATH_AND_LANG for  $0 $1 $2 $3 $4 $5 $6 $7 
else
    echo Create and call temp/langs_testFiles.bat
    $MX cipar=$FILE_CIPAR seq=$FILE_PATH_AND_LANG lw=9999 "pft=if v1='601' and '$OLANG'=v4 then else './$BATCHES_PATH/genDBLang/get601or602.bat $1 ',v1,' $PATH_FILES/',v2,' ',if v1='601' then '$OEXT' else v3 fi,' ',v4,' \"',if v4<>'$OLANG' then v4,'_' fi,'$FILENAME_NOEXT\" $DIR_ACRON_ISSUE $OLANG $procFile'/ fi" now > temp/langs_testFiles.bat
    chmod 775 temp/langs_testFiles.bat
    ./temp/langs_testFiles.bat
fi


echo      [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG