. $1

echo Executing $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG

FILENAME=$2
ACRON_ISSUE=$3
OLANG=$4
$MX cipar=$FILE_CIPAR seq=$PROCLANG_PATH/tables/lang_paths.seq "pft=./$BATCHES_PATH/get601or602.bat $PATH_FILES/',v1,' ',v2,' ',v3,' ',v4,' $FILENAME $ACRON_ISSUE $OLANG'/" > temp/langs_testFiles.bat

if [ "@mount" == "@true" ]
then
    #mount $MOUNT_FROM $MOUNT_DEST
fi
chmod 775 temp/langs_testFiles.bat
./temp/langs_testFiles.bat

if [ "@mount" == "@true" ]
then
    #umount $MOUNT_DEST
fi
echo Executed $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG