rem FIXED 20040504 
rem	Roberta Mayumi Takenaka
rem Solicitado por Solange email: 20040429
rem Não gerar sempre o arquivo xml rule
rem Solução: alterar a scilista.lst incluindo YES para gerar o arquivo rule

rem FIXED 20040504 
rem	Roberta Mayumi Takenaka
rem Solicitado por Solange email: 20040429
rem copiar os arquivos xml para o diretorio \serial\

rem FIXED 20040504 
rem	Roberta Mayumi Takenaka
rem Substituição do uxt por php

md %PUBMED_DIR_COPY%
md %Serial_Directory%%1
md %Serial_Directory%%1\PubMed\

ECHO %JAVA_TRANSFORMATION%
if not %JAVA_TRANSFORMATION%=="" goto JAVA_TRANSFORMATION

:PHP_TRANSFORMATION
echo php
if not "@%2"=="@NONE" echo Generating %CURRENT_DIR%\PubMed\%1%2.xml (%CURRENT_DIR%\temp\%1%2.xml, %3)
if not "@%2"=="@NONE" echo %PHP_TRANSFORMATION% %CURRENT_DIR%\temp\%1%2.xml %3 %CURRENT_DIR%\PubMed\%1%2.xml
if not "@%2"=="@NONE" %PHP_TRANSFORMATION% %CURRENT_DIR%\temp\%1%2.xml %3 %CURRENT_DIR%\PubMed\%1%2.xml
if not "@%4"=="@NONE" echo Generating %CURRENT_DIR%\PubMed\journals_%1.xml (%CURRENT_DIR%\temp\%1%2.xml, %4)
if not "@%4"=="@NONE" echo %PHP_TRANSFORMATION% %CURRENT_DIR%\temp\%1%2.xml %4 %CURRENT_DIR%\PubMed\journals_%1.xml
if not "@%4"=="@NONE" %PHP_TRANSFORMATION% %CURRENT_DIR%\temp\%1%2.xml %4 %CURRENT_DIR%\PubMed\journals_%1.xml
echo end php

goto END
 
:JAVA_TRANSFORMATION
echo java 
if not "@%2"=="@NONE" echo Generating %CURRENT_DIR%\PubMed\%1%2.xml (%CURRENT_DIR%\temp\%1%2.xml, %3)
if not "@%2"=="@NONE" %JAVA_TRANSFORMATION%  -jar %XML_SCIELO_PROGRAM_PATH%\proc\java\saxon8.jar %CURRENT_DIR%\temp\%1%2.xml %3 > %CURRENT_DIR%\PubMed\%1%2.xml

if not "@%4"=="@NONE" echo Generating %CURRENT_DIR%\PubMed\journals_%1.xml (%CURRENT_DIR%\temp\%1%2.xml, %4)
if not "@%4"=="@NONE" %JAVA_TRANSFORMATION%  -jar %XML_SCIELO_PROGRAM_PATH%\proc\java\saxon8.jar  %CURRENT_DIR%\temp\%1%2.xml %4 > %CURRENT_DIR%\PubMed\journals_%1.xml
echo end java

:END
if not "@%2"=="@NONE" copy PubMed\%1%2.xml %Serial_Directory%%1\PubMed\%1%2%5.xml
if not "@%2"=="@NONE" copy PubMed\%1%2.xml %PUBMED_DIR_COPY%\%1%2%5.xml

if not "@%4"=="@NONE" echo copy PubMed\journals_%1.xml %Serial_Directory%%1\PubMed\journals_%1.xml
if not "@%4"=="@NONE" copy PubMed\journals_%1.xml %Serial_Directory%%1\PubMed\journals_%1.xml
if not "@%4"=="@NONE" echo copy PubMed\journals_%1.xml %PUBMED_DIR_COPY%\journals_%1.xml
if not "@%4"=="@NONE" copy PubMed\journals_%1.xml %PUBMED_DIR_COPY%\journals_%1.xml
