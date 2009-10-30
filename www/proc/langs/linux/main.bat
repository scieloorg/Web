# opcional, se sem scilista significa que eh total
SCILISTA=$1


. langs/config/config.inc

echo Executing $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG
./$BATCHES_PATH/genLangsVsPaths.bat $FILE_CONFIG

if [ ! -f $PROCLANG_PATH/config/docpaths.mst ]
then
	$MX seq=$DOCPATHS create=$PROCLANG_PATH/config/docpaths now -all
	echo created $PROCLANG_PATH/config/docpaths
fi


######################################
# PREPARA UMA SCILISTA COM PID DE ISSUE
#
echo > $NEW_SCILISTA
if [ "@$SCILISTA" == "@" ]
then
    # processamento completo
	$MX null count=1 create=$DBLANG now -all
	$MX $DBLANG fst=@$PROCLANG_PATH/fst/lang.fst fullinv=$DBLANG
	echo created $DBLANG
    echo S > $NEW_SCILISTA
else
    # processamento parcial, baseado na scilista
    # prepara
    if [ -f $TEMP_DBLANG.mst ]
    then
        rm $TEMP_DBLANG.*
    fi
    # gerar uma nova scilista com ISSUE PID
    if [ -f $DBLANG.mst ]
    then
        # existe DBLANG, entao os registros a atualizar devem ser apagados antes
    	$MX $DBLANG create=$TEMP_DBLANG now -all
        $MX $TEMP_DBLANG fst=@$PROCLANG_PATH/fst/lang.fst fullinv=$TEMP_DBLANG

        $MX cipar=$FILE_CIPAR seq=$SCILISTA lw=9999 "pft=if p(v1) and size(v1)>0 then '$BATCHES_PATH/getIssuePID.bat $1 $NEW_SCILISTA ',v1/,'$BATCHES_PATH/deleteRecordsDBLang.bat $1 ',v1/ fi" now> temp/langs_getIssuePID.bat
    else
        $MX cipar=$FILE_CIPAR seq=$SCILISTA lw=9999 "pft=if p(v1) and size(v1)>0 then '$BATCHES_PATH/getIssuePID.bat $1 $NEW_SCILISTA ',v1/, fi" now> temp/langs_getIssuePID.bat
    fi
    chmod 775 temp/langs_getIssuePID.bat
    temp/langs_getIssuePID.bat

    # existe TEMP_DBLANG, entao os registros a atualizar FORAM apagados
    # e recriar a base DBLANG sem os registros apagados
    if [ -f $TEMP_DBLANG.mst ]
    then
    	$MX null count=0 create=$DBLANG now -all
        $MX $TEMP_DBLANG append=$DBLANG now -all
        $MX $DBLANG fst=@$PROCLANG_PATH/fst/lang.fst fullinv=$DBLANG
        rm $TEMP_DBLANG.*
    fi
fi

######################################
# CRIA DBLANG SE AINDA NAO FOI CRIADA
#
if [ ! -f $DBLANG.mst ]
then
	$MX null count=1 create=$DBLANG now -all
	$MX $DBLANG fst=@$PROCLANG_PATH/fst/lang.fst fullinv=$DBLANG
	echo created $DBLANG
fi

######################################


$MX seq=$NEW_SCILISTA lw=9999 "pft=if p(v1) then '$BATCHES_PATH/doForIssue.bat $1 ',v1,/ fi" now> temp/langs_DoForIssue.bat
chmod 775 temp/langs_DoForIssue.bat
temp/langs_DoForIssue.bat

$MX $DBLANG fst=@$PROCLANG_PATH/fst/lang.fst fullinv=$DBLANG

echo Executed $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG