# opcional, se sem scilista significa que eh total
SCILISTA=$1


. langs/config/config.inc

./$PROCLANG_PATH/config/umount.bat

chmod 775 langs/*/*.bat

echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5 > $PROCLANG_LOG
./$BATCHES_PATH/genLangsVsPaths.bat $FILE_CONFIG


if [ ! -d $PATH_DBLANG ]
then
	mkdir -p $PATH_DBLANG
fi
######################################
# PREPARA UMA SCILISTA COM PID DE ISSUE
#
echo PREPARA UMA SCILISTA COM PID DE ISSUE   >> $PROCLANG_LOG

echo > $NEW_SCILISTA
if [ "@$SCILISTA" == "@" ]
then
    # processamento completo
	echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executa full   >> $PROCLANG_LOG
    echo S > $NEW_SCILISTA
else
    # processamento parcial, baseado na scilista
    # prepara
    echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executa parcial    >> $PROCLANG_LOG
    
    # gerar uma nova scilista com ISSUE PID
    $MX cipar=$FILE_CIPAR seq=$SCILISTA lw=9999 "pft=if p(v1) and size(v1)>0 then '$BATCHES_PATH/getIssuePID.bat $FILE_CONFIG $NEW_SCILISTA ',v1/, fi" now> temp/langs_getIssuePID.bat
    chmod 775 temp/langs_getIssuePID.bat
    ./temp/langs_getIssuePID.bat
fi

######################################
# CRIA DBLANG SE AINDA NAO FOI CRIADA
#
if [ ! -f $DBLANG.mst ]
then
	$MX null count=1 "proc='a777{',date,'{'" create=$DBLANG now -all
	$MX $DBLANG fst=@$PROCLANG_PATH/fst/lang.fst fullinv=$DBLANG
	echo No DBLANG. Then create $DBLANG   >> $PROCLANG_LOG
fi

######################################

echo >> $NEW_SCILISTA
$MX seq=$NEW_SCILISTA lw=9999 "pft=if p(v1) then '$BATCHES_PATH/doForIssue.bat $FILE_CONFIG ',v1,/ fi" now> temp/langs_DoForIssue.bat
chmod 775 temp/langs_DoForIssue.bat
./temp/langs_DoForIssue.bat
    
$MX $DBLANG fst=@$PROCLANG_PATH/fst/lang.fst fullinv=$DBLANG

#chmod 775 ./$BATCHES_PATH/reports/common/generateDB4Tab.bat
#./$BATCHES_PATH/reports/common/generateDB4Tab.bat $FILE_CONFIG

./$PROCLANG_PATH/config/umount.bat

