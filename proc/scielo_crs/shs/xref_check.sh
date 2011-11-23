. crossref_config.sh

col=scl

LOG_FILE=$MYTEMP/DOI_CHECK.log
SCRIPT_TO_REPROC=$MYTEMP/DOI_CHECK_REPROC.sh 
PID_LIST_TO_REPROC_DOI=$MYTEMP/DOI_CHECK_PID_LIST_TO_REPROC.txt
DB_DOI_QUERY=../../../bases/doi/query

NEW_DB_DOI=../databases/crossref/doi


$cisis_dir/mx seq=../gizmo/ent.seq create=../gizmo/ent now -all
$cisis_dir/mx seq=../gizmo/ent2.seq create=../gizmo/ent2 now -all


if [ ! -f $NEW_DB_DOI.fst ]
then
	cp ../fst/crossref_DOIReport.fst $NEW_DB_DOI.fst	
fi

if [ ! -f $NEW_DB_DOI.mst ]
then
  if [ -f $DB_DOI_QUERY.mst ]
  then
    sh ./xref_check_tool_import_doi_query_to_new_doi.sh $DB_DOI_QUERY $depositor_prefix $col $NEW_DB_DOI
  else
    $cisis_dir/mx $XREF_DOI_REPORT count=1  append=$NEW_DB_DOI now -all
	$cisis_dir/mx $NEW_DB_DOI fst=@ fullinv=$NEW_DB_DOI
  fi
    
fi

if [ -f $NEW_DB_DOI.mst ]
then
  if [ -f $DB_DOI_QUERY.mst ]
  then
    $cisis_dir/mx $XREF_DOI_REPORT btell=0 "bool=hr=$ and not (st=error)" "proc=if l(['$NEW_DB_DOI']'hr=',v880)>0 or l(['$DB_DOI_QUERY']'pid=',v880)>0  then 'd*' fi" append=$NEW_DB_DOI now -all
    $cisis_dir/mx $NEW_DB_DOI fst=@ fullinv=$NEW_DB_DOI
  else
    $cisis_dir/mx $XREF_DOI_REPORT btell=0 "bool=hr=$ and not (st=error)" "proc=if l(['$NEW_DB_DOI']'hr=',v880)>0 then 'd*' fi" append=$NEW_DB_DOI now -all
    $cisis_dir/mx $NEW_DB_DOI fst=@ fullinv=$NEW_DB_DOI
  fi
fi

$cisis_dir/mx $NEW_DB_DOI btell=0 "bool=$  and not (CHECKED)" lw=9999 "pft=if p(v880) and a(v237)  then 'sh ./xref_check_doi_for_pid.sh ',v880,' $conversor_dir/output/crossref/',v880*1.9, '/',v880*10.4,'/',v880*14.4,'/',v880*18,'.xml $PID_LIST_TO_REPROC_DOI $SCRIPT_TO_REPROC $LOG_FILE $NEW_DB_DOI' # fi" now > $MYTEMP/call_xref_check_doi_for_pid.sh

if [ -f $MYTEMP/call_xref_check_doi_for_pid.sh ]
then
	echo executar $MYTEMP/call_xref_check_doi_for_pid.sh
   sh $MYTEMP/call_xref_check_doi_for_pid.sh
fi

if [ -f $LOG_FILE ]
then
	$cisis_dir/mx seq=$LOG_FILE create=$MYTEMP/DOI_CHECK_LOG now -all
	$cisis_dir/mxtb $MYTEMP/DOI_CHECK_LOG create=$MYTEMP/DOI_CHECK_stat "100:v2" 
	$cisis_dir/mx $MYTEMP/DOI_CHECK_stat "pft=if (v1='doi_query' or v1='crossref') and val(v999)>0 then 'INVERT' fi"  now > $MYTEMP/DOI_CHECK_reproc.txt
	$cisis_dir/mx $MYTEMP/DOI_CHECK_stat now
fi



#INVERT=`cat $MYTEMP/DOI_CHECK_reproc.txt`
INVERT=NO

if [ "@$INVERT" == "@INVERT" ]
then
echo invert $NEW_DB_DOI
	echo inverter $NEW_DB_DOI
	$cisis_dir/mx $NEW_DB_DOI fst=@ fullinv=$NEW_DB_DOI
fi

if [ -f $SCRIPT_TO_REPROC ]
then
echo executar $SCRIPT_TO_REPROC
  sh $SCRIPT_TO_REPROC
fi
