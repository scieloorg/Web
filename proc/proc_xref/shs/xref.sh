PARAM_COL=$1
PARAM_DB_C_READONLY=$2
PARAM_DB_H_READONLY=$3
PARAM_PATH_NEW_DB_DOI=$4
PARAM_SIMULTANEO=$5

echo ...........  Executing $0 $1 $2 $3 $4 $5

. config.sh


PATH_LOG=../log
PATH_WRK=../wrk/doi.$PARAM_COL


DB_SRC=$PATH_WRK/src

if [ -f $PARAM_PATH_NEW_DB_DOI/query.mst ]
then
DB_NEW_DOI_READONLY=$PARAM_PATH_NEW_DB_DOI/query
cp $DB_NEW_DOI_READONLY.??? $PATH_WRK
fi

FILE_CONTROL=$MYTEMP/$PARAM_COL.FILE_CONTROL

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
cp ../fst/ref.fst $PATH_WRK/query.fst
echo 1 > $FILE_CONTROL 

# h + c = src
$MX null count=0 create=$DB_SRC now -all
if [ -f $PARAM_DB_C_READONLY.mst ]
then
	./reglog.sh $0 append $PARAM_DB_C_READONLY $DB_SRC 
	$MX $PARAM_DB_C_READONLY append=$DB_SRC now -all
fi
if [ -f $PARAM_DB_H_READONLY.mst ]
then
	./reglog.sh $0 append $PARAM_DB_H_READONLY $DB_SRC 
	$MX $PARAM_DB_H_READONLY append=$DB_SRC now -all
fi
if [ -f $DB_SRC.mst ]
then
	echo ". config.sh"> $MYTEMP/$PARAM_COL.call_xref_select.sh
	echo >$PATH_WRK/retry.seq
	echo >$PATH_WRK/done.seq
	echo >$PATH_WRK/new.seq
	
	$MX null count=0 create=$PATH_WRK/newpid now -all
	./reglog.sh $0 how many records $DB_SRC has
	$MX $DB_SRC +control now
	
	./reglog.sh $0 generate $MYTEMP/$PARAM_COL.call_xref_select.sh
	$MX $DB_SRC "proc='a9001{$PATH_WRK{a9002{$DB_SRC{a9003{$DB_NEW_DOI_READONLY{'" lw=9999 "pft=@../pft/xref_select.pft" now >> $MYTEMP/$PARAM_COL.call_xref_select.sh
	./reglog.sh $0 execute $MYTEMP/$PARAM_COL.call_xref_select.sh
	sh  $MYTEMP/$PARAM_COL.call_xref_select.sh
	
	
	./reglog.sh $0  $PARAM_SIMULTANEO
	if [ "@$PARAM_SIMULTANEO" == "@" ]
	then
		./reglog.sh $0 ./xref_4status.sh new
		./xref_4status.sh new $PATH_WRK $FILE_CONTROL $PARAM_PATH_NEW_DB_DOI 8
		./reglog.sh $0 ./xref_4status.sh retry
		./xref_4status.sh retry $PATH_WRK $FILE_CONTROL $PARAM_PATH_NEW_DB_DOI 1
	else
		./reglog.sh $0 nohup ./xref_4status.sh new $PATH_WRK $FILE_CONTROL $PARAM_PATH_NEW_DB_DOI 8
		nohup ./xref_4status.sh new $PATH_WRK $FILE_CONTROL $PARAM_PATH_NEW_DB_DOI 8 >$PATH_LOG/$PARAM_COL.new.out&
		./reglog.sh $0 nohup ./xref_4status.sh retry $PATH_WRK $FILE_CONTROL $PARAM_PATH_NEW_DB_DOI 1
		nohup ./xref_4status.sh retry $PATH_WRK $FILE_CONTROL $PARAM_PATH_NEW_DB_DOI 1 >$PATH_LOG/$PARAM_COL.retry.out&
		
	fi
	
fi


./reglog.sh $0 FINISHED

