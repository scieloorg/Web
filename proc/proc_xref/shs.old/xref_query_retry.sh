. config.sh

./reglog.sh $0  "..... Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"

# DB_NEW_DOI_READONLY.seq each line is a xml file of a record 
DB_NEW_DOI_READONLY=$1
MAX_QTY_DOC_PER_XML=$2
STATUS=$3
WRK_NEW_DB_DOI=$4
CONTROL=$5
NEW_DB_DOI_PATH=$6


./reglog.sh "Generate $MYTEMP/$COL.call_xref_query_generate_xml_$STATUS.sh"	
$MX $DB_NEW_DOI_READONLY btell=0 "bool=$ and not (DOI=$)" lw=9999 "pft=if size(v880)>0 then if instr(v237,'/')=0  then 'sh ./xref_query_generate_xml.sh  ',v880,#  fi fi" now >> $MYTEMP/$COL.call_xref_query_generate_xml_$STATUS.sh

./reglog.sh "Execute $MYTEMP/$COL.call_xref_query_generate_xml_$STATUS.sh"
sh $MYTEMP/$COL.call_xref_query_generate_xml_$STATUS.sh 


if [ -f $DB_NEW_DOI_READONLY.seq ]
then 
   
	$MX seq=$DB_NEW_DOI_READONLY.seq create=$DB_NEW_DOI_READONLY now -all
	$MX $DB_NEW_DOI_READONLY "pft=mfn/" now | sort -r > $MYTEMP/c
	$MX  seq=$MYTEMP/c count=1 "pft=v1" now >  $MYTEMP/qtd
	
	QTD=`cat $MYTEMP/qtd`
	./reglog.sh $0  ... $QTD records    
	
	START=1
	QUERY_RESULT=$DB_NEW_DOI_READONLY.res
	echo > $QUERY_RESULT

	./reglog.sh $0  Create  $QUERY_RESULT
	while [ $START -lt $QTD ]
		do
			# create a XML file which contains $MAX_QTY_DOC_PER_XML xml files of a record
			QUERY_XML_FILE=$DB_NEW_DOI_READONLY.$START.xml			
			$MX null count=1 "proc='a9000{$depositor_email{a9001{',replace(date,' ','-'),'{'"  lw=999 "pft=@../pft/begin.pft" now > $QUERY_XML_FILE
			$MX $DB_NEW_DOI_READONLY from=$START count=$MAX_QTY_DOC_PER_XML lw=99999 "pft=if size(v1)>0 then 'cat 'v1' >> $QUERY_XML_FILE; rm ',v1,# fi,#" now > $DB_NEW_DOI_READONLY.xml.sh
			sh $DB_NEW_DOI_READONLY.xml.sh
			rm $DB_NEW_DOI_READONLY.xml.sh
			$MX null count=1 lw=999 "pft=@../pft/end.pft" now >> $QUERY_XML_FILE
		    
		    # submit to CrossRef
			cd ../crossref
			pwd
			echo ./CrossRefQuery.sh -f $QUERY_XML_FILE -t d -a live -u $crossrefUserName -p $crossrefPassword -r piped
			echo $QUERY_RESULT
			sh ./CrossRefQuery.sh -f $QUERY_XML_FILE -t d -a live -u $crossrefUserName -p $crossrefPassword -r piped      >> $QUERY_RESULT
			cd ../shs
			rm $QUERY_XML_FILE
			
		    START=`expr $START + $MAX_QTY_DOC_PER_XML`
    done
    # treat result
    if [ -f $QUERY_RESULT ]
    then
    	./reglog.sh $0 "Get result. Read $QUERY_RESULT"
    	tail -n 100  $QUERY_RESULT
    	$MX seq=$QUERY_RESULT lw=999 "pft=if size(v11)>0 or size(v9)>0 then 'sh ./xref_query_get_result.sh $WRK_NEW_DB_DOI ',if size(v11)>0 then v11,' ',v12,# else v9,' ',v10,# fi fi" now > $DB_NEW_DOI_READONLY.res.sh
    	./reglog.sh $0  Execute $DB_NEW_DOI_READONLY.res.sh
		sh  $DB_NEW_DOI_READONLY.res.sh
		rm  $DB_NEW_DOI_READONLY.res.sh
    fi
    
fi    
echo $STATUS finished >> $CONTROL 

$MX seq=$CONTROL create=$CONTROL now -all
$MX $CONTROL from=4 count=1 "pft=v1" now > $MYTEMP/finished

FINISHED=`cat $MYTEMP/finished`

if [  "@$FINISHED" != "@" ]
then
    $MXTB $WRK_NEW_DB_DOI create=$MYTEMP/DOI_QUERY_stat "100:v300" class=1000000
	$MX $MYTEMP/DOI_QUERY_stat now
	
	
	./reglog.sh $0  "Invert $WRK_NEW_DB_DOI"
	$MX $WRK_NEW_DB_DOI fst=@ fullinv=$WRK_NEW_DB_DOI
	./reglog.sh $0  "copy $WRK_NEW_DB_DOI.* to $NEW_DB_DOI_PATH" 
	cp $WRK_NEW_DB_DOI.* $NEW_DB_DOI_PATH
	
fi

./reglog.sh $0  "FINISHED $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"

  