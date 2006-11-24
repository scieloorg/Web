rem DelDirVazio
rem Parametro 1: diretorio

call batch\VerifPresencaParametro.bat %0 @%1 nome do diretorio a deletar

rmdir %1
if not exist %1 call batch\InformaLog.bat %0 x Deleta diretorio: %1
