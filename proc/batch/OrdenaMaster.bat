rem OrdenaMaster
rem Parametro 1: base de dados
rem Parametro 2: tamanho da expressao
rem Parametro 3: formato ordenacao

call batch/VerifPresencaParametro.bat $0 @$1 base de dados
call batch/VerifExisteBase.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 tamanho da chave
call batch/VerifPresencaParametro.bat $0 @$3 formato de ordenacao

call batch/InformaLog.bat $0 x Ordena master: $1
$CISIS_DIR/msrt $1 $2 @$3
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 msrt $1 $2 @$3
