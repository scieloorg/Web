@echo off

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem set SHELL=C:\COMMAND.COM /P /E:1024

rem Envia2Medline
rem Parametro 1: código revista SciELO
rem Parametro 2: volnum da revista
rem Parametro 3: ID da revista cx alta

rem Inicializa variaveis
set INFORMALOG=log\Envia2Lilacs.log
set CISIS_DIR=cisis

rem Verifica parametros
call batch\VerifPresencaParametro.bat %0 @%1 código revista SciELO
call batch\VerifPresencaParametro.bat %0 @%2 volum de revista
call batch\VerifPresencaParametro.bat %0 @%3 ID revista CxAlta
call batch\VerifExisteArquivo.bat transf\Envia2LilacsLogOn.txt

if "%4"=="cria" call batch\DeletaArquivo.bat %INFORMALOG%

call batch\InformaLog.bat %0 dh ===Inicio===

call batch\CriaDiretorio.bat temp\transf2lilacs

if exist temp\templilacs1.mst del temp\templilacs1.mst
if exist temp\templilacs1.xrf del temp\templilacs1.xrf
if exist temp\templilacs2.mst del temp\templilacs2.mst
if exist temp\templilacs2.xrf del temp\templilacs2.xrf

rem fixed 3003-12-03
call batch\GeraInvertido.bat ..\bases-work\title\title fst\title.fst ..\bases-work\title\title

REM fixed 2003-12-15
%CISIS_DIR%\mx ..\..\serial\%1\%2\base\%2 cipar=cipar\Envia2Lilacs.cip "proc=@prc\geraLilacsRecord.prc" append=temp\templilacs1 now -all
%CISIS_DIR%\mxcp temp\templilacs1 create=temp\templilacs2 clean
%CISIS_DIR%\mx temp\templilacs2 "proc=@prc\check.prc" "proc='s'" iso=temp\transf2lilacs\%1%2.iso now -all

copy transf\Envia2LilacsLogOn.txt temp\Envia2LilacsLogOn.txt
echo mkdir %3>>temp\Envia2LilacsLogOn.txt
echo cd %3>>temp\Envia2LilacsLogOn.txt
echo put %1%2.iso>>temp\Envia2LilacsLogOn.txt
echo cd ..>>temp\Envia2LilacsLogOn.txt
echo bye>>temp\Envia2LilacsLogOn.txt

call batch\InformaLog.bat %0 x FTP iso LILACS
ftp -s:temp\Envia2LilacsLogOn.txt >> %INFORMALOG%
if errorlevel==1 batch\AchouErro.bat %0 ftp: temp\Envia2LilacsLogOn.txt

call batch\InformaLog.bat %0 dh ===Fim=== LOG gravado em: %INFORMALOG%

