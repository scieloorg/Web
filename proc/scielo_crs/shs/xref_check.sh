. crossref_config.sh

col=scl

LOG_FILE=$MYTEMP/DOI_CHECK.log
SCRIPT_TO_REPROC=$MYTEMP/DOI_CHECK_REPROC.sh 
PID_LIST_TO_REPROC_DOI=$MYTEMP/DOI_CHECK_PID_LIST_TO_REPROC.txt
DB_DOI_QUERY=../../../bases/doi/query

NEW_DB_DOI=../databases/crossref/doi

ART=$database_dir/artigo/artigo
echo $ART

$cisis_dir/mx seq=../gizmo/ent.seq create=../gizmo/ent now -all
$cisis_dir/mx seq=../gizmo/ent2.seq create=../gizmo/ent2 now -all

if [ -f $LOG_FILE ]
then
	rm $LOG_FILE
fi
if [ -f $SCRIPT_TO_REPROC ]
then
	rm $SCRIPT_TO_REPROC
fi

if [ ! -f $NEW_DB_DOI.fst ]
then
	echo create $NEW_DB_DOI.fst
	cp ../fst/doi.fst $NEW_DB_DOI.fst	
fi

if [ ! -f $NEW_DB_DOI.mst ]
then
  if [ -f $DB_DOI_QUERY.mst ]
  then
  	echo import doi db from doi query db
    sh ./xref_check_tool_import_doi_query_to_new_doi.sh $DB_DOI_QUERY $depositor_prefix $col $NEW_DB_DOI
  else
     echo create doi db from $XREF_DOI_REPORT
    $cisis_dir/mx $ART btell=0 hr=$ count=1 "proc='d*','a880{',v880,'{',|a881{|v881|{|,|a891{|v891|{|,|a237{|v237|{|"  append=$NEW_DB_DOI now -all
	
  fi
    
fi

$cisis_dir/mx $NEW_DB_DOI fst=@ fullinv=$NEW_DB_DOI

echo $ART
if [ -f $NEW_DB_DOI.mst ]
then
  if [ -f $DB_DOI_QUERY.mst ]
  then
    echo read $ART, and check $DB_DOI_QUERY and $NEW_DB_DOI, then create new records for $NEW_DB_DOI
    echo `date '+%Y%m%d %H:%M:%S'`
    $cisis_dir/mx $ART btell=0 "bool=hr=$"  "proc='a9000{$NEW_DB_DOI{a9001{$DB_DOI_QUERY{'" "proc=@../prc/xref_check_create_reg.prc" append=$NEW_DB_DOI now -all
    $cisis_dir/mx $NEW_DB_DOI fst=@ fullinv=$NEW_DB_DOI
  else
  	echo read $ART, and check $NEW_DB_DOI, then create new records for $NEW_DB_DOI
  	echo `date '+%Y%m%d %H:%M:%S'`
    $cisis_dir/mx $ART btell=0 "bool=hr=$" "proc='a9000{$NEW_DB_DOI{'" "proc=@../prc/xref_check_create_reg.prc" append=$NEW_DB_DOI now -all
    $cisis_dir/mx $NEW_DB_DOI fst=@ fullinv=$NEW_DB_DOI
  fi
fi

echo generate xref_check_doi_for_pid.sh
echo `date '+%Y%m%d %H:%M:%S'`
$cisis_dir/mx $NEW_DB_DOI btell=0 "bool=$  and not (DOI=$)" lw=9999 "pft=if size(v880)>0 then if instr(v237,'/')=0  then 'sh ./xref_check_doi_for_pid.sh ',v880,,' $conversor_dir/output/crossref/',v880*1.9, '/',v880*10.4,'/',v880*14.4,'/',v880*18,'.xml $LOG_FILE $NEW_DB_DOI',' ', v881,,if p(v881) then ' $conversor_dir/output/crossref/',v881*1.9, '/',v881*10.4,'/',v881*14.4,'/',v881*18,'.xml', fi, ' ', v891,if p(v891) then ' $conversor_dir/output/crossref/',v891*1.9, '/',v891*10.4,'/',v891*14.4,'/',v891*18,'.xml',fi #  fi fi" now > $MYTEMP/call_xref_check_doi_for_pid.sh

if [ -f $MYTEMP/call_xref_check_doi_for_pid.sh ]
then
	echo executar $MYTEMP/call_xref_check_doi_for_pid.sh
   sh $MYTEMP/call_xref_check_doi_for_pid.sh
fi

if [ -f $LOG_FILE ]
then
	echo Tab $LOG_FILE
	$cisis_dir/mx "seq=$LOG_FILE " create=$MYTEMP/DOI_CHECK_LOG now -all
	$cisis_dir/mxtb $MYTEMP/DOI_CHECK_LOG create=$MYTEMP/DOI_CHECK_stat "100:v2" class=1000000
	$cisis_dir/mx $MYTEMP/DOI_CHECK_stat "pft=if v1='crossref' and val(v999)>0 then 'INVERT'/ fi"  now | sort -u> $MYTEMP/DOI_CHECK_reproc.txt
	$cisis_dir/mx $MYTEMP/DOI_CHECK_stat now
fi



	echo inverter $NEW_DB_DOI
	$cisis_dir/mx $NEW_DB_DOI fst=@ fullinv=$NEW_DB_DOI

#if [ -f $SCRIPT_TO_REPROC ]
#then
#echo executar $SCRIPT_TO_REPROC
#  sh $SCRIPT_TO_REPROC
#fi
echo $0 finished.