

export SCILIL_ISSUE_SRCDB=$1
export SCILIL_ISSUE_DEST=$2

export SCILIL_ISSUE_ISSUEPID=$3

export SCILIL_ISSUE_ACRON=$4
export SCILIL_ISSUE_STATUS=$5

export SCILIL_ISSUE_WXISLOG=$6

export SCILIL_ISSUE_CF=$7
export SCILIL_ISSUE_CTRL_CONVERSION=$8

export SCILIL_ISSUE_proc_path=scielo2lilacs/

echo Executing $0 $4 $3 $5 

if [ "@$SCILIL_ISSUE_STATUS" == "@QUALIFIED" ]
then
	# $SCILIL_MX $SCILIL_ISSUE_SRCDB lw=9999 btell=0 "bool=PID=S$SCILIL_ISSUE_ISSUEPID$" "pft='scielo2lilacs/linux/doForArticle.bat $SCILIL_WXIS $SCILIL_ISSUE_SRCDB $SCILIL_ISSUE_DEST ',mfn,' $SCILIL_ISSUE_proc_path $SCILIL_ISSUE_CF'/" now> temp/scielo2lilacs_DoForArticle.bat

	$SCILIL_MX $SCILIL_ISSUE_SRCDB lw=9999 btell=0 "bool=PID=S$SCILIL_ISSUE_ISSUEPID$" "pft='$SCILIL_WXIS IsisScript=scielo2lilacs/xis/convert.xis src=$SCILIL_ISSUE_SRCDB mfn=',mfn,'  dest=$SCILIL_ISSUE_DEST proc_path=$SCILIL_ISSUE_proc_path  cipar_file=$SCILIL_ISSUE_CF  check=yes debug=On >> $SCILIL_ISSUE_WXISLOG'/" now> temp/scielo2lilacs_DoForArticle.bat

	echo Executing temp/scielo2lilacs_DoForArticle.bat

	chmod 775 temp/scielo2lilacs_DoForArticle.bat
	./temp/scielo2lilacs_DoForArticle.bat

	if [ "@$SCILIL_ISSUE_CTRL_CONVERSION" == "@" ]
	then
		echo No CTRL_CONVERSION
		read
	else
		scielo2lilacs/linux/invert.bat $SCILIL_MX $SCILIL_ISSUE_CTRL_CONVERSION scielo2lilacs/fst/ctrl_conversion.fst 
	fi
	scielo2lilacs/linux/invert.bat $SCILIL_MX $SCILIL_ISSUE_DEST scielo2lilacs/fst/dbresult.fst 
	
fi
echo Controling $SCILIL_ISSUE_ACRON $SCILIL_ISSUE_ISSUEPID
$SCILIL_WXIS IsisScript=scielo2lilacs/xis/controlIssue.xis issuePID=$SCILIL_ISSUE_ISSUEPID acron=$SCILIL_ISSUE_ACRON status=$SCILIL_ISSUE_STATUS src=$SCILIL_ISSUE_SRCDB dest=$SCILIL_ISSUE_DEST cipar_file=$SCILIL_ISSUE_CF proc_path=$SCILIL_ISSUE_proc_path debug=On>> $SCILIL_ISSUE_WXISLOG


