@echo off

set mx=cisis\mx

mkdir ..\bases-aux\lilacs-scielo\temp
mkdir ..\bases-aux\lilacs-scielo\ctrl
mkdir \scielo\serial.lilacs

if not exist ..\bases-aux\lilacs-scielo\ctrl\ctrl_issue %mx% null count=0 create=..\bases-aux\lilacs-scielo\ctrl\ctrl_issue
if not exist ..\bases-aux\lilacs-scielo\ctrl\ctrl_issue.cnt %mx% ..\bases-aux\lilacs-scielo\ctrl\ctrl_issue fst=@lilacs_scielo\conversion\fst\ctrl_issue.fst fullinv=..\bases-aux\lilacs-scielo\ctrl\ctrl_issue

if not exist ..\bases-aux\lilacs-scielo\ctrl\ctrl_conversion %mx% null count=0 create=..\bases-aux\lilacs-scielo\ctrl\ctrl_conversion
if not exist ..\bases-aux\lilacs-scielo\ctrl\ctrl_conversion.cnt %mx% ..\bases-aux\lilacs-scielo\ctrl\ctrl_conversion fst=@lilacs_scielo\conversion\fst\ctrl_conversion.fst fullinv=..\bases-aux\lilacs-scielo\ctrl\ctrl_conversion

call lilacs_scielo\tools\getConfig.bat %mx% lilacs_scielo\config\config.ini temp\lilacs_scielo_config.bat
call lilacs_scielo\geralista %LILACS%.iso mioc.txt
call lilacs_scielo\conversion\call_conversion.bat mioc.txt %mx% 
call lilacs_scielo\report\call_report.bat cisis\mx ..\htdocs\lilacs_scielo_diff.htm ..\htdocs\lilacs_scielo_geral.htm 


