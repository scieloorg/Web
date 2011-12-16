. config.sh
STATUS=$1
COL=$2
XML_FILE_LIST1=$3
WRK_NEW_DB_DOI=$4
CONTROL=$5
PATH_NEW_DB_DOI=$6
PATH_LOG=$7
QTD=$8

./reglog.sh "Generate $MYTEMP/$COL.call_xref_query_generate_xml_$STATUS.sh"	
$MX $WRK_NEW_DB_DOI btell=0 "bool=$ and status=$STATUS" lw=9999 "pft=if size(v880)>0 then if instr(v237,'/')=0  then 'sh ./xref_query_generate_xml.sh  ',v9003,' ',v9004,' $XML_FILE_LIST1' #  fi fi" now >> $MYTEMP/$COL.call_xref_query_generate_xml_$STATUS.sh

./reglog.sh "Execute $MYTEMP/$COL.call_xref_query_generate_xml_$STATUS.sh"
sh $MYTEMP/$COL.call_xref_query_generate_xml_$STATUS.sh 

./reglog.sh  Submit $STATUS
sh ./xref_query_submit.sh $XML_FILE_LIST1 $QTD $STATUS $WRK_NEW_DB_DOI $CONTROL $PATH_NEW_DB_DOI

