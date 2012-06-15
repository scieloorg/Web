. config.sh

PARAM_DB_WRK_DOI=$1
PARAM_DB_SRC=$2

PARAM_DB_READONLY_NEW_DOI=$4

PARAM_COL=$6
PARAM_FILE_CONTROL=$5
PARAM_PATH_DB_NEW_DOI=$6
PARAM_PATH_LOG=$7
PARAM_QTD=$8

DB_NEWPID=$PARAM_DB_WRK_DOI.new
STATUS=new
DB_XML_LIST=$DB_NEWPID.xml

if [ -f $PARAM_DB_SRC.mst ]
then
  	./reglog.sh "Read $PARAM_DB_SRC and create new records for $DB_NEWPID"
  	$MX $PARAM_DB_SRC "proc='a9000{$PARAM_DB_READONLY_NEW_DOI{a9003{$PARAM_DB_SRC{a9004{',mfn,'{'" "proc=@../prc/xref_query_create_reg.prc" append=$DB_NEWPID now -all
fi

./reglog.sh "Generate $MYTEMP/$PARAM_COL.call_xref_query_generate_xml_$STATUS.sh"	
$MX $DB_NEWPID lw=9999 "pft=if size(v880)>0 then if instr(v237,'/')=0  then 'sh ./xref_query_generate_xml.sh  ',v9003,' ',v9004,' $DB_XML_LIST' #  fi fi" now >> $MYTEMP/$PARAM_COL.call_xref_query_generate_xml_$STATUS.sh

./reglog.sh "Execute $MYTEMP/$PARAM_COL.call_xref_query_generate_xml_$STATUS.sh"
sh $MYTEMP/$PARAM_COL.call_xref_query_generate_xml_$STATUS.sh 

./reglog.sh  Submit $STATUS
sh ./xref_query_submit.sh $DB_XML_LIST $PARAM_QTD $STATUS $DB_NEWPID $PARAM_FILE_CONTROL $PARAM_PATH_DB_NEW_DOI


if [ -f $DB_NEWPID.mst ]
then


	./reglog.sh "Append $DB_NEWPID to $PARAM_DB_WRK_DOI"
  	$MX $DB_NEWPID append=$PARAM_DB_WRK_DOI now -all
	
  	
fi
  