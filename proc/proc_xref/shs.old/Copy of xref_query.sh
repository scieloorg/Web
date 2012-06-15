COL=$1
DB_C_READONLY=$2
DB_H_READONLY=$3
PATH_NEW_DB_DOI=$4

echo ...........  Executing $0 $1 $2 $3 $4 $5

. config.sh


PATH_LOG=../log
PATH_WRK=../wrk/doi.$COL
WRK_NEW_DB_DOI=$PATH_WRK/doi

CONTROL=$MYTEMP/$COL.control

XML_FILE_LIST1=$PATH_WRK/new
XML_FILE_LIST2=$PATH_WRK/notfound
XML_FILE_LIST3=$PATH_WRK/query

$MX seq=../gizmo/ent.seq create=../gizmo/ent now -all
$MX seq=../gizmo/ent2.seq create=../gizmo/ent2 now -all



if [ ! -d $PATH_LOG ]
then
	mkdir -p $PATH_LOG
fi

if [ ! -d $PATH_WRK ]
then
	mkdir -p $PATH_WRK
fi

if [ ! -d $MYTEMP ]
then
	mkdir -p $MYTEMP
fi

if [ -f $DB_QUERY.mst ]
then 
	DB_QUERY_READONLY=$DB_QUERY
fi

if [ -f $DB_DOI_BR.mst ]
then
	DB_DOI_READONLY=$DB_DOI_BR
fi

if [ -f $PATH_NEW_DB_DOI/doi.mst ]
then
	DB_NEW_DOI_READONLY=$PATH_NEW_DB_DOI/doi
fi

if [ -f $XML_FILE_LIST1.mst ]
then 
	rm $XML_FILE_LIST1.*
fi

if [ -f $XML_FILE_LIST2.mst ]
then 
	rm $XML_FILE_LIST2.*
fi

if [ -f $XML_FILE_LIST3.mst ]
then 
	rm $XML_FILE_LIST3.*
fi

if [ ! -f $WRK_NEW_DB_DOI.fst ]
then
	cp ../fst/ref.fst $WRK_NEW_DB_DOI.fst
fi


if [ -f $DB_C_READONLY.mst ]
then
	./reglog.sh "Read $DB_C_READONLY and create new records for $WRK_NEW_DB_DOI"
  	$MX $DB_C_READONLY "proc='a9000{$DB_NEW_DOI_READONLY{a9001{$DB_QUERY_READONLY{a9002{$DB_DOI_READONLY{a9003{$DB_C_READONLY{a9004{',mfn,'{'" "proc=@../prc/xref_query_create_reg.prc" append=$WRK_NEW_DB_DOI now -all
fi

echo $DB_H_READONLY
echo `date '+%Y%m%d %H:%M:%S'`
if [ -f $DB_H_READONLY.mst ]
then
  	./reglog.sh "Read $DB_H_READONLY and create new records for $WRK_NEW_DB_DOI"
  	$MX $DB_H_READONLY "proc='a9000{$DB_NEW_DOI_READONLY{a9001{$DB_QUERY_READONLY{a9002{$DB_DOI_READONLY{a9003{$DB_H_READONLY{a9004{',mfn,'{'" "proc=@../prc/xref_query_create_reg.prc" append=$WRK_NEW_DB_DOI now -all
fi


if [ -f $WRK_NEW_DB_DOI.mst ]
then
	./reglog.sh "Invert $WRK_NEW_DB_DOI"
  	$MX $WRK_NEW_DB_DOI fst=@ fullinv=$WRK_NEW_DB_DOI
	./reglog.sh ".. inverted $WRK_NEW_DB_DOI"
  	
	echo 1 > $CONTROL 
	echo > $MYTEMP/$COL.call_xref_query_generate_xml_new.sh
	echo > $MYTEMP/$COL.call_xref_query_generate_xml_notfound.sh
	echo > $MYTEMP/$COL.call_xref_query_generate_xml_query.sh
	

	./reglog.sh "Generate $MYTEMP/$COL.call_xref_query_generate_xml_new.sh"
	$MX $WRK_NEW_DB_DOI btell=0 "bool=$ and status=new"      lw=9999 "pft=if size(v880)>0 then if instr(v237,'/')=0  then 'sh ./xref_query_generate_xml.sh  ',v9003,' ',v9004,' $XML_FILE_LIST1' #  fi fi" now >> $MYTEMP/$COL.call_xref_query_generate_xml_new.sh
	
	tail -n 100 $MYTEMP/$COL.call_xref_query_generate_xml_new.sh
	
	./reglog.sh "Execute $MYTEMP/$COL.call_xref_query_generate_xml_new.sh"
	sh $MYTEMP/$COL.call_xref_query_generate_xml_new.sh 
	
	./reglog.sh  Submit new
	nohup sh ./xref_query_submit.sh $XML_FILE_LIST1 1 new $WRK_NEW_DB_DOI $CONTROL $PATH_NEW_DB_DOI>$PATH_LOG/$COL.new.out&
	./reglog.sh Read $PATH_LOG/$COL.new.out
	
	./reglog.sh "Generate $MYTEMP/$COL.call_xref_query_generate_xml_notfound.sh"
	$MX $WRK_NEW_DB_DOI btell=0 "bool=$ and status=notfound" lw=9999 "pft=if size(v880)>0 then if instr(v237,'/')=0  then 'sh ./xref_query_generate_xml.sh  ',v9003,' ',v9004,'  $XML_FILE_LIST2' #  fi fi" now >> $MYTEMP/$COL.call_xref_query_generate_xml_notfound.sh
	tail -n 100 $MYTEMP/$COL.call_xref_query_generate_xml_notfound.sh
	./reglog.sh "Execute $MYTEMP/$COL.call_xref_query_generate_xml_notfound.sh"
	sh $MYTEMP/$COL.call_xref_query_generate_xml_notfound.sh
	
	./reglog.sh  Submit notfound 
	nohup sh ./xref_query_submit.sh $XML_FILE_LIST2 1 notfound $WRK_NEW_DB_DOI  $CONTROL $PATH_NEW_DB_DOI>$PATH_LOG/$COL.notfound.out&
	./reglog.sh Read $PATH_LOG/$COL.notfound.out
	
	./reglog.sh "Generate $MYTEMP/$COL.call_xref_query_generate_xml_query.sh"
	$MX $WRK_NEW_DB_DOI btell=0 "bool=$ and status=query"    lw=9999 "pft=if size(v880)>0 then if instr(v237,'/')=0  then 'sh ./xref_query_generate_xml.sh  ',v9003,' ',v9004,'  $XML_FILE_LIST3' #  fi fi" now >> $MYTEMP/$COL.call_xref_query_generate_xml_query.sh
	tail -n 100 $MYTEMP/$COL.call_xref_query_generate_xml_query.sh
	./reglog.sh "Execute $MYTEMP/$COL.call_xref_query_generate_xml_query.sh"
	sh $MYTEMP/$COL.call_xref_query_generate_xml_query.sh
	
	./reglog.sh  Submit query
	nohup sh ./xref_query_submit.sh $XML_FILE_LIST3 1 query $WRK_NEW_DB_DOI  $CONTROL $PATH_NEW_DB_DOI>$PATH_LOG/$COL.query.out&
	./reglog.sh Read $PATH_LOG/$COL.query.out
	
fi
./reglog.sh $0 FINISHED

