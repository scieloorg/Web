echo report.bat reportName reportResult debug

export reportName=$1
export reportResult=$2
export debug=$3
export executionReport=$4

if [ "$1" == "generateDiffReport" ]
then
	$wxis IsisScript=scielo_lilacs/report/$reportName.xis proc_path=$proc_path reportFile=$reportResult executionReport=$executionReport debug=$debug cip=$cip
else
	$wxis IsisScript=scielo_lilacs/report/$reportName.xis proc_path=$proc_path debug=$debug  cip=$cip> $reportResult
fi


