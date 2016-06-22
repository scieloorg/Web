. crossref_config.sh

LOGFILE=$1
PID=$2
#OK or error
STATUS=$3


MFN=`$cisis_dir/mx $XREF_DOI_REPORT "btell=0" "HR=$PID" "pft= mfn(0)" -all now`

if [ $MFN > 0 ]; then
    if [ ! $STATUS = 'error' ]
    then
        $cisis_dir/mx $XREF_DOI_REPORT  from=$MFN count=1  "proc='d10d930d30a30{update{a930{$LOGFILE{a10{',date,'{'" copy=$XREF_DOI_REPORT -all now
    else
    	$cisis_dir/mx $XREF_DOI_REPORT  from=$MFN count=1  "proc='d10d930d30a30{error{a930{$LOGFILE{a10{',date,'{'" copy=$XREF_DOI_REPORT -all now
    fi
else            
    if [ ! $STATUS = 'error' ]
    then
        $cisis_dir/mx null  count=1 "proc='a30{new{a930{$LOGFILE{a880{$PID{a10{',date,'{'" append=$XREF_DOI_REPORT -all now
    else
    	$cisis_dir/mx null  count=1 "proc='a30{error{a930{$LOGFILE{a880{$PID{a10{',date,'{'" append=$XREF_DOI_REPORT -all now
    fi
fi
if [ -f $XREF_DOI_REPORT.mst ]
then
    $cisis_dir/mx $XREF_DOI_REPORT fst=@$conversor_dir/fst/crossref_DOIReport.fst fullinv=$XREF_DOI_REPORT 
fi
