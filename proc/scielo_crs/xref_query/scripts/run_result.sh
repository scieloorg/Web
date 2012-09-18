MX=$1
PATH_RESULT=$2
PATH_TEMP=$3
PATH_DBQUERY=$4
DBQUERY_NAME=$5
LOGFILE=$6
COLLECTION=$7
PATH_XML=$8

DBQUERY=$PATH_DBQUERY/$DBQUERY_NAME
TEMPDB=$PATH_TEMP/$DBQUERY_NAME
RESULT=$PATH_TEMP/get_result

if [ "@$8" == "@" ]
then
	echo Missing Parameter8 PATH_XML
else
if [ "@$7" == "@" ]
then
	echo Missing Parameter7 COLLECTION
else
if [ "@$6" == "@" ]
then
	echo Missing Parameter6 LOGFILE
else
if [ "@$5" == "@" ]
then
	echo Missing Parameter5 DBQUERY_NAME
else
if [ "@$4" == "@" ]
then
	echo Missing Parameter4 PATH_DBQUERY
else
if [ "@$3" == "@" ]
then
	echo Missing Parameter3 PATH_TEMP
else
if [ "@$2" == "@" ]
then
	echo Missing Parameter2 PATH_RESULT
else
if [ "@$1" == "@" ]
then
	echo Missing Parameter1 MX
else
    d=`date '+%Y%m%d-%H%M%S'`
    if [ ! -d $PATH_TEMP ]
    then
        mkdir -p $PATH_TEMP
    fi
    if [ ! -f $DBQUERY.mst ]
    then
        if [ ! -d $PATH_DBQUERY ]
        then
            mkdir -p $PATH_DBQUERY
        fi
        $MX null count=0 create=$TEMPDB now -all
    else
        $MX $DBQUERY create=$TEMPDB now -all
    fi
    
    cat $PATH_RESULT/result.* > $RESULT
    if [ -f $RESULT ]
    then
        $MX seq=$RESULT lw=9999 "proc='a9000{$PATH_XML{'"  "pft=@scripts/archive.pft" now > $PATH_TEMP/archive.sh
        sh $PATH_TEMP/archive.sh
        $MX seq=$RESULT "proc='a9000{$COLLECTION{'" "proc=@scripts/result.prc" append=$TEMPDB now -all
        $MX $TEMPDB fst=@scripts/ref.fst fullinv=$TEMPDB
    fi
    copy $TEMPDB.* $PATH_DBQUERY
    
fi
fi
fi
fi
fi
fi
fi
fi
