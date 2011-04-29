@echo off
echo Parameter 1 scilista
echo Parameter 2 mx



if exist %log_file% del %log_file%

notepad %1
echo Press Enter to continue or Press CTRL+C to end
pause> nul

%mx% null count=0 create=%TEMP_DB% now -all

copy %TITLE%.* %MY_TITLE%.*
%mx% %MY_TITLE% "fst=@lilacs_scielo\conversion\fst\title.fst" fullinv=%MY_TITLE%

if not exist %ISSUE_DB%.mst %mx% null count=0 create=%ISSUE_DB%
%mx% %ISSUE_DB% fst=@lilacs_scielo\conversion\fst\issues.fst fullinv=%ISSUE_DB% 

%mx% %ISSUE_ORDER% fst=@lilacs_scielo\conversion\fst\issues.fst fullinv=%ISSUE_ORDER% 
%mx% seq=lilacs_scielo\gizmo\hifen.seq create=lilacs_scielo\gizmo\hifen now -all

%mx% iso=%LILACS%.iso create=%LILACS% now -all
%mx% %LILACS% "proc='d8814d9014d9015a9014{',v14,'{a9015{',v14,'{'" copy=%LILACS% now -all

%mx% %LILACS% "gizmo=lilacs_scielo\gizmo\hifen,32,9014" "proc=@lilacs_scielo\conversion\fst\pages.prc"    copy=%LILACS% now -all

%mx% %LILACS% "fst=@lilacs_scielo\conversion\fst\lilacs.fst" fullinv=%LILACS%

if not exist %CTRL_ISSUE%.mst %mx% null count=0 create=%CTRL_ISSUE% now -all
%mx% %CTRL_ISSUE% fst=@lilacs_scielo\conversion\fst\ctrl_issue.fst fullinv=%CTRL_ISSUE% 

if not exist %CTRL_CONVERSION%.mst %mx% null count=0 create=%CTRL_CONVERSION% now -all
%mx% %CTRL_CONVERSION% fst=@lilacs_scielo\conversion\fst\ctrl_conversion.fst fullinv=%CTRL_CONVERSION% 

%mx% seq=%1 lw=9999 "pft='call lilacs_scielo\conversion\call_issue_conversion.bat ',v1,' ',v2,' ',v3/" now > temp\lilacs_scielo_call_issue_conversion.bat

call temp\lilacs_scielo_call_issue_conversion.bat

%mx% %CTRL_ISSUE% fst=@lilacs_scielo\conversion\fst\ctrl_issue.fst fullinv=%CTRL_ISSUE% 
%mx% %CTRL_CONVERSION% fst=@lilacs_scielo\conversion\fst\ctrl_conversion.fst fullinv=%CTRL_CONVERSION% 


