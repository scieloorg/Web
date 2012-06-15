PARAM_COL=$1
PARAM_DB_C_READONLY=$2
PARAM_DB_H_READONLY=$3
PARAM_PATH_NEW_DB_DOI=$4

echo ...........  Executing $0 $1 $2 $3 $4 $5

. config.sh


PATH_LOG=../log
PATH_WRK=../wrk/doi.$PARAM_COL

DB_NEW_DOI_WRK=$PATH_WRK/doi
DB_NEWPID=$PATH_WRK/newpid
DB_SRC=$PATH_WRK/src
DB_NEW_DOI_READONLY=$PARAM_PATH_NEW_DB_DOI/doi

FILE_CONTROL=$MYTEMP/$PARAM_COL.FILE_CONTROL

$MX seq=../gizmo/ent.seq create=../gizmo/ent now -all
$MX seq=../gizmo/ent2.seq create=../gizmo/ent2 now -all
cp ../fst/ref.fst $DB_NEW_DOI_WRK.fst

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




echo 1 > $FILE_CONTROL 

if [ -f $DB_NEW_DOI_READONLY.mst ]
then
	#./reglog.sh "Invert $DB_NEW_DOI_READONLY"
  	#$MX $DB_NEW_DOI_READONLY fst=@ fullinv=$DB_NEW_DOI_READONLY
	#./reglog.sh ".. inverted $DB_NEW_DOI_READONLY"

	
fi
$MX null count=0 create=$DB_SRC now -all
if [ -f $PARAM_DB_C_READONLY.mst ]
then
	$MX $PARAM_DB_C_READONLY append=$DB_SRC now -all
fi
if [ -f $PARAM_DB_H_READONLY.mst ]
then
	$MX $PARAM_DB_H_READONLY append=$DB_SRC now -all
fi
./reglog.sh Create new records
nohup ./xref_query_create_new.sh $DB_SRC $PARAM_DB_C_READONLY $DB_NEW_DOI_READONLY $DB_QUERY_READONLY >$PATH_LOG.$PARAM_COL.new.log&

./reglog.sh $0 FINISHED

