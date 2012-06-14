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

DB_NEWPID=$PATH_WRK/newpid
XML_FILE_LIST1=$PATH_WRK/new
XML_FILE_LIST2=$PATH_WRK/notfound
XML_FILE_LIST3=$PATH_WRK/query
DB_SRC=$PATH_WRK/src

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

echo 1 > $CONTROL 
echo > $MYTEMP/$COL.call_xref_query_generate_xml_new.sh
echo > $MYTEMP/$COL.call_xref_query_generate_xml_notfound.sh
echo > $MYTEMP/$COL.call_xref_query_generate_xml_query.sh

if [ -f $WRK_NEW_DB_DOI.mst ]
then
	./reglog.sh "Invert $WRK_NEW_DB_DOI"
  	$MX $WRK_NEW_DB_DOI fst=@ fullinv=$WRK_NEW_DB_DOI
	./reglog.sh ".. inverted $WRK_NEW_DB_DOI"

	./reglog.sh Execute xref_query_4status.sh notfound
	nohup ./xref_query_4status.sh notfound $COL $XML_FILE_LIST2 $WRK_NEW_DB_DOI $CONTROL $PATH_NEW_DB_DOI $PATH_LOG 7>$PATH_LOG.$COL.notfound.log&
	./reglog.sh Execute xref_query_4status.sh query
	nohup ./xref_query_4status.sh query    $COL $XML_FILE_LIST3 $WRK_NEW_DB_DOI $CONTROL $PATH_NEW_DB_DOI $PATH_LOG 1>$PATH_LOG.$COL.query.log&
fi
$MX null count=0 create=$DB_SRC now -all
if [ -f $DB_C_READONLY.mst ]
then
	$MX $DB_C_READONLY append=$DB_SRC now -all
fi
if [ -f $DB_H_READONLY.mst ]
then
	$MX $DB_H_READONLY append=$DB_SRC now -all
fi
./reglog.sh Create new records
nohup ./xref_query_create_new.sh $DB_SRC $DB_C_READONLY $DB_NEW_DOI_READONLY $DB_QUERY_READONLY >$PATH_LOG.$COL.new.log&

./reglog.sh $0 FINISHED

