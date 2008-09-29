
set scilista=%1
set initial_date=%2
set report=%3
set debug=%4
set reportQuantity=%5
set reportErrorsTxt=%6
set reportErrors=%7

cat scielo_lilacs\tools\config.bat > temp\convert_and_report.bat
cat scielo_lilacs\config\config.bat >> temp\convert_and_report.bat
cat scielo_lilacs\conversion\convert_and_report_aux.bat >> temp\convert_and_report.bat

call temp\convert_and_report.bat
