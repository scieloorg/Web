@echo off

call lilacs_scielo\conversion\call_conversion.bat scilista.txt cisis\mx 
call lilacs_scielo\report\call_report.bat cisis\mx ..\htdocs\lilacs_scielo_diff.htm ..\htdocs\lilacs_scielo_geral.htm 