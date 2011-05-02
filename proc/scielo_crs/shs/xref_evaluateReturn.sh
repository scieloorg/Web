. crossref_config.sh

RETURNEDFILE=$1
FILEID=$2
PID=$3
ANSWER=$4
DATE=$5

if [ -f $RETURNEDFILE ]
then


	if [ -f $MYTEMP/xref_answer_$PID.txt ]
	then 
		rm $MYTEMP/xref_answer_$PID.txt
	fi

	$cisis_dir/mx null count=1 "pft=#" now >> $RETURNEDFILE
	$cisis_dir/mx "seq=$RETURNEDFILE" count=1 "pft=	if instr(v1,'$PID')> 0 then ,if '$ANSWER'='update-new' then ,if l(['$XREF_DOI_REPORT']'hr=$PID')>0 then ,'update', ,else ,'new', fi, ,else ,'$ANSWER',	,fi ,fi" now> $MYTEMP/xref_answer_$PID.txt

	GETANSWER=`cat $MYTEMP/xref_answer_$PID.txt`
	if [ "@$GETANSWER" == "@" ]
	then
		rm $MYTEMP/xref_answer_$PID.txt	
	else
		rm $MYTEMP/xref_answer_$PID.txt
		STATUS=`$cisis_dir/mx $XREF_DOI_REPORT "btell=0" "HR=$PID" "pft= mfn(0)" -all now`

		if [ $STATUS > 0 ]; then			
			$cisis_dir/mx $XREF_DOI_REPORT  from=$STATUS count=1  "proc='d10d30a30/$GETANSWER/a930/$RETURNEDFILE/a10/',date,'/'" copy=$XREF_DOI_REPORT -all now
		else			
			$cisis_dir/mx null  count=1 "proc='a30/$GETANSWER/a930/$RETURNEDFILE/a880/$PID/a10/',date,'/'" append=$XREF_DOI_REPORT -all now
		fi
		if [ -f $XREF_DOI_REPORT.mst ]
		then
			$cisis_dir/mx $XREF_DOI_REPORT fst=@$conversor_dir/fst/crossref_DOIReport.fst fullinv=$XREF_DOI_REPORT 
		fi

	fi
fi
