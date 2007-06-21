rem DeletaArquivo
rem Parametro 1: arquivo

call batch\VerifPresencaParametro.bat %0 @%1 nome do arquivo a deletar

call batch\InformaLog.bat %0 x Deleta arquivo: %1
if exist %1 del %1
