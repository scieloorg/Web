rem MostraQuantidadeRegistros
rem Parametro 1: base de entrada

call batch/VerifPresencaParametro.bat $0 @$1 base de entrada
call batch/VerifExisteBase.bat $1

$CISIS_DIR/mx $1 +control now 
