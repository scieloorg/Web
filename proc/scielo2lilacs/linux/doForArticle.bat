
export WXIS=$1

export SRCDB=$2
export DBRESULT=$3

export MFN=$4
export proc_path=$5
export cipar_file=$6

$WXIS IsisScript=scielo2lilacs/xis/convert.xis src=$SRCDB mfn=$MFN dest=$DBRESULT proc_path=$proc_path  cipar_file=$cipar_file check=yes debug=On 

