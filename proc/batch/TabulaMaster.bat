rem TabulaMaster
rem Parametro 1: base entrada
rem Parametro 2: base com resultado da tabulacao
rem Parametro 3: tamanho da chave
rem Parametro 4: formato tabulacao

call batch/VerifPresencaParametro.bat $0 @$1 base_de_dados a ser lida
call batch/VerifExisteBase.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 base para armazenar resultado tabulacao
call batch/VerifPresencaParametro.bat $0 @$3 tamanho da chave
call batch/VerifPresencaParametro.bat $0 @$4 formato de tabulacao

call batch/InformaLog.bat $0 x Tabula Master: $1
$CISIS_DIR/mxtb $1 create=$2 "$3:@$4"
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mxtb $1 create:$2 "$3:@$4"
