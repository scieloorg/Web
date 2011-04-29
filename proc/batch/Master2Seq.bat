rem Master2Seq.bat
rem Parametro 1: base de dados
rem Parametro 2: formato do seq
rem Parametro 3: arquivo seq

call batch/VerifPresencaParametro.bat $0 @$1 base de dados
call batch/VerifExisteBase.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 formato para gera arquivo seq
call batch/VerifExisteArquivo.bat $2
call batch/VerifPresencaParametro.bat $0 @$3 arquivo seq

call batch/InformaLog.bat $0 x Gera Seq: $3
$CISIS_DIR/mx $1 lw=9000 pft=@$2 now > $3
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $1 pft:@$2 saida:$3
