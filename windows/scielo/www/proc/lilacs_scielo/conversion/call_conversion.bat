@echo off
echo Parameter 1 scilista
echo Parameter 2 mx

if "@"=="%2" goto END
call lilacs_scielo\tools\getConfig.bat %2 lilacs_scielo\config\config.ini temp\lilacs_scielo_config.bat


%mx% null count=0 create=%TEMP_DB% now -all

copy %TITLE%.* %MY_TITLE%.*
%mx% %MY_TITLE% "fst=@lilacs_scielo\conversion\fst\title.fst" fullinv=%MY_TITLE%

if not exist %ISSUE_DB%.mst %mx% null count=0 create=%ISSUE_DB%
%mx% %ISSUE_DB% fst=@lilacs_scielo\conversion\fst\issues.fst fullinv=%ISSUE_DB% 

%mx% %LILACS% "fst=@lilacs_scielo\conversion\fst\lilacs.fst" fullinv=%LILACS%

if not exist %CTRL_ISSUE%.mst %mx% null count=0 create=%CTRL_ISSUE% now -all
%mx% %CTRL_ISSUE% fst=@lilacs_scielo\conversion\fst\ctrl_issue.fst fullinv=%CTRL_ISSUE% 

if not exist %CTRL_CONVERSION%.mst %mx% null count=0 create=%CTRL_CONVERSION% now -all
%mx% %CTRL_CONVERSION% fst=@lilacs_scielo\conversion\fst\ctrl_conversion.fst fullinv=%CTRL_CONVERSION% 

%mx% seq=%1 "pft='call lilacs_scielo\conversion\call_issue_conversion.bat ',v1,' ',v2,' ',v3/" now > temp\lilacs_scielo_call_issue_conversion.bat

call temp\lilacs_scielo_call_issue_conversion.bat

%mx% %CTRL_ISSUE% fst=@lilacs_scielo\conversion\fst\ctrl_issue.fst fullinv=%CTRL_ISSUE% 
%mx% %CTRL_CONVERSION% fst=@lilacs_scielo\conversion\fst\ctrl_conversion.fst fullinv=%CTRL_CONVERSION% 


:END
if "@"=="%2" echo Missing second parameter mx 
