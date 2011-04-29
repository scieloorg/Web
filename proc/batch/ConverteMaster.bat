rem ConverteMaster
rem Parametro 1: base a converter
rem Parametro 2: base convertida

call batch/VerifPresencaParametro.bat $0 @$1 base a converter
call batch/VerifPresencaParametro.bat $0 @$2 base convertida
call batch/VerifExisteBase.bat $1

call batch/InformaLog.bat $0 x Converte base de dados: $1 em: $2

$CISIS_DIR/crunchmf $1 $2
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 crunchmf $1 $2
