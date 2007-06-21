@echo off
rem CopiaDiretorio
rem Parametro 1: diretorio a ser lido
rem Parametro 2: diretorio a ser gravado

call batch\VerifPresencaParametro.bat %0 @%1 diretorio a ser lido
call batch\VerifPresencaParametro.bat %0 @%2 diretorio a ser gravado

call batch\InformaLog.bat %0 x Copia Diretorio: %1 em: %2
xcopy %1 %2 /E /I /Q /Y