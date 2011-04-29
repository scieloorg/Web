@echo off
echo Parameter 1 mx
echo Parameter 2 diff_report
echo Parameter 3 issue_report

if "@"=="%1" goto END
call lilacs_scielo\tools\getConfig.bat %1 lilacs_scielo\config\config.ini temp\lilacs_scielo_config.bat

%wxis% IsisScript=lilacs_scielo\report\generateDiffReport.xis cip=%cipar_file% report=%2% 
%wxis% IsisScript=lilacs_scielo\report\generateIssueReport.xis cip=%cipar_file%  report=%3

echo Read diff report in %2
echo Read issue report in %3


:END
if "@"=="%1" echo Missing first parameter mx 
