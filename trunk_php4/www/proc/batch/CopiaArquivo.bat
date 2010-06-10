rem CopiaArquivo
rem Parametro 1: arquivo a ser copiado
rem Parametro 2: arquivo a ser gravado

call batch/VerifPresencaParametro.bat $0 @$1 nome do arquivo a ser copiado
call batch/VerifExisteArquivo.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 nome do arquivo a ser gravado

call batch/InformaLog.bat $0 x Copia arquivo: $1 em: $2
cp $1 $2
