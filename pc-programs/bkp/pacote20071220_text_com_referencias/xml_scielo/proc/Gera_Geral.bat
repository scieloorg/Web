@echo off

rem Inicializa variaveis
set SHELL=C:\COMMAND.COM /P /E:1024
set CISIS_DIR=cisis

rem Set parametros para execucao
call batch\ReadConfigFile.bat

Set PATH_DB=%Serial_Directory%
Set PROGRAM_PATH=%XML_SCIELO_PROGRAM_PATH%

rem opcoes de execucao
set OPTION=cria
set ID=%PUBMED_PROVIDER_ID%
set NAME_XML=journals

md temp

echo setting php 
if exist %PHP_EXE% set PHP_TRANSFORMATION=%PHP_EXE% -f php\xml_xsl.php
echo setting java
set JAVA_TRANSFORMATION="%JAVA_EXE%"

echo testing
set TRANSF=%PHP_EXE% %JAVA_EXE%

if "%TRANSF%"==" " goto END

ECHO ...

set CURRENT_DIR=%XML_SCIELO_PROGRAM_PATH%\proc
set XSL=%CURRENT_DIR%\xsl\Pubmed.xsl
set XSL_LINK=%CURRENT_DIR%\xsl\Pubmed_Link.xsl
set FST=fst\xml_scielo.fst
set LOG=log\AtualizaLattesOnLine.log
set SCI_LISTA=%XML_SCIELO_PROGRAM_PATH%\scilista.lst

rem arquivos de configuração do programa
set DOI_CONF=%XML_SCIELO_PROGRAM_PATH%\config\PubMed\doi_conf.txt
set CONFIG=%XML_SCIELO_PROGRAM_PATH%\config\PubMed\config\config
set JOURNALS=%XML_SCIELO_PROGRAM_PATH%\config\PubMed\journals\journals

rem bases de dados
set TITLE=%Serial_Directory%title\title
set TEMP_TITLE=temp\title
SET CIPAR_FILE=arquivo_cipar.cip

echo TITLE.mst=%TITLE%.mst > %CIPAR_FILE%
echo TITLE.xrf=%TITLE%.xrf >> %CIPAR_FILE%
echo TEMP_TITLE.cnt=%TEMP_TITLE%.cnt >> %CIPAR_FILE%
echo TEMP_TITLE.n01=%TEMP_TITLE%.n01 >> %CIPAR_FILE%
echo TEMP_TITLE.n02=%TEMP_TITLE%.n02 >> %CIPAR_FILE%
echo TEMP_TITLE.l01=%TEMP_TITLE%.l01 >> %CIPAR_FILE%
echo TEMP_TITLE.l02=%TEMP_TITLE%.l02 >> %CIPAR_FILE%
echo TEMP_TITLE.ifp=%TEMP_TITLE%.ifp >> %CIPAR_FILE%

rem FIXED 20040504 
rem	Roberta Mayumi Takenaka
rem Solicitado por Solange email: 20040429
rem Não gerar sempre o arquivo xml rule
rem Solução: alterar a scilista.lst incluindo YES para gerar o arquivo rule
if not exist %SCI_LISTA% copy %SCI_LISTA_SITE% %SCI_LISTA%

rem FIXED 20040504 
rem	Roberta Mayumi Takenaka
rem Solicitado por Solange email: 20040429
rem Apresentar o conteúdo de scilista.lst para confirmar

echo === ATENCAO ===
echo Este arquivo executara a geração de xml para Pubmed das seguintes revistas
echo.
echo Tecle CONTROL-C para sair ou ENTER para verificar as revistas...

pause > nul

call notepad "%SCI_LISTA%"

cls
echo === ATENCAO ===
echo.
echo Serao gerados os xml para serem enviados ao Pubmed
echo.
echo Tecle CONTROL-C para sair ou ENTER para continuar...

echo Apaga
call batch\Apagatemp.bat
echo Pubmed_xml.bat
call PubMed_xml.bat

goto END

:ERROR
echo Missing PHP_EXE or JAVA_EXE

:END
echo fim