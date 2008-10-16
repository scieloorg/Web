echo report.bat reportName reportResult debug executionReport

echo %0 %1 %2 %3 %4

set reportName=%1
set reportResult=%2
set debug=%3
set executionReport=%4

if "%1" == "generateDiffReport" %wxis% IsisScript=scielo_lilacs\report\%reportName%.xis proc_path=%proc_path% executionReport=%executionReport% reportFile=%reportResult% debug=%debug% cip=%cip%
if not "%1" == "generateDiffReport" %wxis% IsisScript=scielo_lilacs\report\%reportName%.xis proc_path=%proc_path% debug=%debug%  cip=%cip% > %reportResult%



