@echo off
rem EnviaTranslationSciELO
rem Parametro 1: path da producao da SciELO
rem Parametro 2: arquivo de logOn FTP
rem Parametro 3: arquivo de log
rem Parametro 4: cria / adiciona
rem Parametro 5: path do site teste da SciELO

rem Inicializa variaveis
set INFORMALOG=log\EnviaTranslationSciELO.log
set CISIS_DIR=cisis

rem Verifica parametros
call batch\VerifPresencaParametro.bat %0 @%1 path da producao da SciELO
call batch\VerifPresencaParametro.bat %0 @%2 arquivo de logOn FTP
call batch\VerifExisteArquivo.bat %2
call batch\VerifPresencaParametro.bat %0 @%3 arquivo de LOG
call batch\VerifPresencaParametro.bat %0 @%4 opcao do LOG: cria/adiciona
call batch\VerifPresencaParametro.bat %0 @%5 path do site de teste da SciELO

if "%4"=="cria" call batch\DeletaArquivo.bat %3
set INFORMALOG=%3

call batch\InformaLog.bat %0 dh ===Inicio===

call batch\VerifExisteArquivo.bat %1\serial\translation.lst
call batch\CopiaArquivo.bat %1\serial\translation.lst temp\scilista-Translation.lst

call batch\TranslationCriaDir.bat %5

rem Gera arquivo de parametros do FTP
call batch\CopiaArquivo.bat %2 temp\EnviaTranslation.txt
echo lcd %5>> temp\EnviaTranslation.txt
%CISIS_DIR%\mx "seq=temp\scilista-Translation.lst " lw=9000 pft=@pft\EnviaTranslation.pft now >> temp\EnviaTranslation.txt
if errorlevel==1 batch\AchouErro.bat %0 mx criacao temp\EnviaTranslation.txt
echo bye >> temp\EnviaTranslation.txt

call batch\InformaLog.bat %0 x FTP dos arquivos translation
ftp -s:temp\EnviaTranslation.txt >> %INFORMALOG%
if errorlevel==1 batch\AchouErro.bat %0 ftp: temp\EnviaTranslation.txt

call batch\TranslationDelDirVazio.bat %5

call batch\InformaLog.bat %0 dh ===Fim=== LOG gravado em: %INFORMALOG%

