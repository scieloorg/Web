rem DeletaArquivo
rem Parametro 1: arquivo

call batch/VerifPresencaParametro.bat $0 @$1 nome do arquivo a deletar

call batch/InformaLog.bat $0 x Deleta arquivo: $1
if [ -f $1 ]
then
   rm $1
fi
