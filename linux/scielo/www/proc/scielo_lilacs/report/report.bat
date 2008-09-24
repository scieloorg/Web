echo report.bat reportName reportResult debug

export reportName=$1
export reportResult=$2
export debug=$3

if [ "$1" == "generateErrorsReport" ]
then
	$wxis IsisScript=scielo_lilacs/report/$reportName.xis proc_path=$proc_path reportFile=$reportResult debug=$debug cip=$cip
else
	$wxis IsisScript=scielo_lilacs/report/$reportName.xis proc_path=$proc_path debug=$debug  cip=$cip> $reportResult
fi


