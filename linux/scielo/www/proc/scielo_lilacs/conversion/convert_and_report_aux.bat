
rm -rf $report $reportErrorsTxt $reportErrors $reportQuantity

scielo_lilacs/conversion/convert.bat $scilista $initial_date $report $debug

scielo_lilacs/report/report.bat generateNumbersReport $reportQuantity $debug 
scielo_lilacs/report/report.bat generateProblemReport $reportErrorsTxt $debug

scielo_lilacs/report/report.bat generateErrorsReport $reportErrors $debug

cat $reportQuantity >> $report
cat $reportErrorsTxt >> $report
echo Read $reportErrors >> $report

echo $idate `date`  >> $report

vi $report

echo Report in $report
echo Errors Report in $reportErrors

echo $idate `date`
