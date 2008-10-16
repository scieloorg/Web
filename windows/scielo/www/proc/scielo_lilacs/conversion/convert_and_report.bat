@echo off

set scilista=%1
set initial_date=%2
set REPORT_LOG=%3
set debug=%4
set PROCESSING_RESULT=%5
set REPORT_NUMBERS=%6
set REPORT_DIFF_IN_TXT=%7
set REPORT_DIFF_IN_HTML=%8

more scielo_lilacs\config\config.bat  > temp\convert_and_report.bat
more scielo_lilacs\tools\config.bat >> temp\convert_and_report.bat
more scielo_lilacs\conversion\convert_and_report_aux.bat >> temp\convert_and_report.bat

call temp\convert_and_report.bat
