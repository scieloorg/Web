export MX=$1
export d=$2
export ISSUEPID=$3

if [ ! -f temp/scielo2lilacs_DBRESULT.mst ]
then
	$MX null count=1 create=temp/scielo2lilacs_DBRESULT now -all
fi

$MX $d btell=0 "bool=$ISSUEPID$" "proc='d*'" copy=temp/scielo2lilacs_DBRESULT now -all

