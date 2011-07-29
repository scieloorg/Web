rem CriaMaster
rem Parametro 1: base de dados a ser criada

call batch/VerifPresencaParametro.bat $0 @$1 base a ser criada

call batch/InformaLog.bat $0 x Cria base de dados: $1
$CISIS_DIR/mx null count=0 create=$1
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx seq:nul create:$1
