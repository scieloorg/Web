/*
$depositor_prefix: v8000
$XREF_DOI_REPORT: v8001
$DB_BILL: v8002
$MYTEMP/doi: v8003
$FIRST_YEAR_OF_RECENT_FEE: v8004
$BACKFILES_FEE: v8005
$RECENT_FEE: v8006
*/
'a9880{',if v880*0.1='S' then if p(v237) and v237:v8000 then v880 else v880 fi, fi,'{',
,if p(v881) then
	'a9001{',
	    ,if l([v8001]'HR='v881) > 0 then
			,ref([v8001]l([v8001]'HR='v881),v10*0.4,'|',v30,'|',v930[1],'|',if v930:'validationErrors_' then 'xml error' else if v930:'crossref_sentError' then 'submission error' else 'ok' fi fi)
	    ,else
			,ref([v8001]l([v8001]'HR='v880),v10*0.4,'|',v30,'|',v930[1],'|',if v930:'validationErrors_' then 'xml error' else if v930:'crossref_sentError' then 'submission error' else 'ok' fi fi)
	    ,fi
	    ,'{',
	,if v8002<>'' then
		'a9002{',
			,if l([v8002]v881) > 0 then
				,ref([v8002]l([v8002]v881),v3*0.4,'|',v2),
			,else
				,ref([v8002]l([v8002]v880),v3*0.4,'|',v2),
			,fi
			'{',
	,fi
	'a9003{',
		,if l([v8003]'PID=',v881) > 0 then
			,ref([v8003]l([v8003]'PID=',v881),v91*0.4,'|',v1)
		,else
			,ref([v8003]l([v8003]'PID=',v880),v91*0.4,'|',v1)
		,fi
		,'{'
,else
	'a9001{',ref([v8001]l([v8001]'HR='v880),v10*0.4,'|',v30,'|',v930[1],'|',if v930:'validationErrors_' then 'xml error' else if v930:'crossref_sentError' then 'submission error' else 'ok' fi fi),'{',
	,if v8002<>'' then
		'a9002{',ref([v8002]l([v8002]v880),v3*0.4,'|',v2),'{',
	,fi
	'a9003{',ref([v8003]l([v8003]'PID='v880),v91*0.4,'|',v1),'{',
,fi
