#python  'path of CrossRefQuery.sh', 'username', 'password', 'e-mail', 'path of new xml files', 'temp path', 'max ref by submission ( < 15)'



PATH_CROSSREF=$1
USERNAME=$2
PASSWORD=$3
EMAIL=$4
PATH_NEW=$5
PATH_TEMP=$6
MAXREF=$7
LOGFILE=$8
PATH_RESULT=$9


if [ "@$9" == "@" ]
then
	echo Missing Parameter9 PATH_RESULT
else
if [ "@$8" == "@" ]
then
	echo Missing Parameter8 LOGFILE
else
if [ "@$7" == "@" ]
then
	echo Missing Parameter7 MAXREF
else
if [ "@$6" == "@" ]
then
	echo Missing Parameter6 PATH_TEMP
else
if [ "@$5" == "@" ]
then
	echo Missing Parameter5 PATH_NEW
else
if [ "@$4" == "@" ]
then
	echo Missing Parameter4 EMAIL
else
if [ "@$3" == "@" ]
then
	echo Missing Parameter3 PASSWORD
else
if [ "@$2" == "@" ]
then
	echo Missing Parameter2 USERNAME
else
if [ "@$1" == "@" ]
then
	echo Missing Parameter1 PATH_CROSSREF
else
    d=`date '+%Y%m%d-%H%M%S'`
    LIST=$PATH_TEMP/new.$d.lst
    RESULT=$PATH_RESULT/result.$d.lst
	if [ -d $PATH_NEW ]
	then
	    curr=`pwd`
	    cd $PATH_NEW
	    find . -name "*.xml" > $LIST
	    cd $curr
	    python scripts/query.py $PATH_CROSSREF $USERNAME $PASSWORD $EMAIL $PATH_TEMP $MAXREF $LIST $RESULT>> $LOGFILE
    fi
fi
fi
fi
fi
fi
fi
fi
fi

fi
