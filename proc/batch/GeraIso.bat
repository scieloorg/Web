rem GeraIso
rem Parametro 1: base
rem Parametro 2: arquivo.iso

call batch/VerifPresencaParametro.bat $0 @$1 base a ser lida
call batch/VerifExisteBase.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 nome-do-arquivo-iso a ser gerado

call batch/InformaLog.bat $0 x Gera arquivo iso: $2
$CISIS_DIR/mx $1 iso=$2 now -all
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $1 iso:$2
