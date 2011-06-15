. crossref_config.sh

if [ ! -f $XREF_DOI_REPORT.mst ]
then
	$cisis_dir/mx null count=1 "proc='a99{',date,'{'" create=$XREF_DOI_REPORT now -all
	$cisis_dir/mx $XREF_DOI_REPORT fst=@$conversor_dir/fst/crossref_DOIReport.fst fullinv=$XREF_DOI_REPORT 
fi

