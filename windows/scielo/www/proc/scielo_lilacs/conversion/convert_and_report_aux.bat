
echo > %report% 
echo > %reportErrorsTxt% 
echo > %reportErrors%
echo > %reportQuantity%

call scielo_lilacs\conversion\convert.bat %scilista% %initial_date% %report% %debug%

call scielo_lilacs\report\report.bat generateNumbersReport %reportQuantity% %debug% 
call scielo_lilacs\report\report.bat generateProblemReport %reportErrorsTxt% %debug%

call scielo_lilacs\report\report.bat generateErrorsReport %reportErrors% %debug%

more %reportQuantity% >> %report%
more %reportErrorsTxt% >> %report%
echo Read %reportErrors% >> %report%

notepad %report%

echo Report in %report%
echo Errors Report in %reportErrors%

