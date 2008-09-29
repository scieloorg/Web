echo report.bat reportName reportResult debug

set reportName=%1
set reportResult=%2
set debug=%3

if "%1" == "generateErrorsReport" %wxis% IsisScript=scielo_lilacs\report\%reportName%.xis proc_path=%proc_path% reportFile=%reportResult% debug=%debug% cip=%cip%
if not "%1" == "generateErrorsReport" %wxis% IsisScript=scielo_lilacs\report\%reportName%.xis proc_path=%proc_path% debug=%debug%  cip=%cip%> %reportResult%



