#./xref_query_pid.sh status $PATH_WRK $FILE_CONTROL $PARAM_PATH_NEW_DB_DOI

. config.sh

PARAM_STATUS=$1
PARAM_PATH_WRK=$2
PARAM_FILE_CONTROL=$3
PARAM_PATH_NEW_DB_DOI=$4
PARAM_QTD_DOC_BY_XML=$5

DB_SRC=$PARAM_PATH_WRK/src
DB_NEWPID=$PARAM_PATH_WRK/newpid
LIST=$PARAM_PATH_WRK/$PARAM_STATUS
WRK_NEW_DB_DOI=$PARAM_PATH_WRK/doi

./reglog.sh $0 PARAM_STATUS=$1 PARAM_PATH_WRK=$2 PARAM_FILE_CONTROL=$3 PARAM_PATH_NEW_DB_DOI=$4 PARAM_QTD_DOC_BY_XML=$5 $6 $7 $8 $9

if [ -f $LIST.seq ]
then 
   
	$MX "seq=$LIST.seq " create=$LIST now -all
	$MX $LIST "pft=mfn/" now | sort -r > $MYTEMP/c
	$MX  seq=$MYTEMP/c count=1 "pft=v1" now >  $MYTEMP/qtd.$PARAM_STATUS
	
	QTD=0`cat $MYTEMP/qtd.$PARAM_STATUS`
	./reglog.sh $0  ... $QTD records    
	
	START=2
	QUERY_RESULT=$LIST.res
	echo > $QUERY_RESULT

	./reglog.sh $0  "Create  $QUERY_RESULT start=$START qtd=$QTD $PARAM_QTD_DOC_BY_XML"
	
	
	while [ $START -lt $QTD ]
		do
			# create a XML file which contains $PARAM_QTD_DOC_BY_XML xml files of a record
			echo $START $QTD $PARAM_QTD_DOC_BY_XML
			QUERY_XML_FILE=$LIST.xml			
			$MX null count=1 "proc='a9000{$depositor_email{a9001{',replace(date,' ','-'),'{'"  lw=999 "pft=@../pft/begin.pft" now > $QUERY_XML_FILE
			echo ". config.sh" > $LIST.xml.sh
			$MX $LIST from=$START count=$PARAM_QTD_DOC_BY_XML  lw=99999 "pft=@../pft/xref_call_generate_xml.pft" now >> $LIST.xml.sh
			sh $LIST.xml.sh >> $QUERY_XML_FILE
			#rm $LIST.xml.sh
			$MX null count=1 lw=999 "pft=@../pft/end.pft" now >> $QUERY_XML_FILE
		    
		    # submit to CrossRef
			cd ../crossref
			pwd
			echo ./CrossRefQuery.sh -f $QUERY_XML_FILE -t d -a live -u $crossrefUserName -p $crossrefPassword -r piped
			echo $QUERY_RESULT
			sh ./CrossRefQuery.sh -f $QUERY_XML_FILE -t d -a live -u $crossrefUserName -p $crossrefPassword -r piped      >> $QUERY_RESULT
			cd ../shs
			rm $QUERY_XML_FILE
			
		    START=`expr $START + $PARAM_QTD_DOC_BY_XML`
    done
    # treat result
    if [ $QTD -gt 1 ]
    then
    	./reglog.sh $0 "Get result. Read $QUERY_RESULT"
    	$MX seq=$QUERY_RESULT lw=999 "proc='a9000{$WRK_NEW_DB_DOI{a9001{$PARAM_STATUS{'" "pft=@../pft/xref_result.pft" now > $LIST.res.sh
    	
    	./reglog.sh $0  Execute $LIST.res.sh
		sh  $LIST.res.sh
		rm  $LIST.res.sh
    fi
    
fi    
echo $PARAM_STATUS finished >> $PARAM_FILE_CONTROL 

$MX seq=$PARAM_FILE_CONTROL create=$PARAM_FILE_CONTROL now -all
$MX $PARAM_FILE_CONTROL from=3 count=1 "pft=v1" now > $MYTEMP/finished

FINISHED=`cat $MYTEMP/finished`

if [  "@$FINISHED" != "@" ]
then
    $MXTB $WRK_NEW_DB_DOI create=$MYTEMP/DOI_QUERY_stat "100:if p(v237) then 'ok' else 'retry' fi" class=1000000
	$MX $MYTEMP/DOI_QUERY_stat now
	
	
	./reglog.sh $0  "Invert $WRK_NEW_DB_DOI"
	$MX $WRK_NEW_DB_DOI fst=@ fullinv=$WRK_NEW_DB_DOI
	./reglog.sh $0  "copy $WRK_NEW_DB_DOI.* to $PARAM_PATH_NEW_DB_DOI" 
	cp $WRK_NEW_DB_DOI.* $PARAM_PATH_NEW_DB_DOI
	
fi

./reglog.sh $0  "FINISHED $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"