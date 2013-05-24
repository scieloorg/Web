MX=$1
BIB4CIT=$2
MFN=$3
PID=$4
XML_QUERY_PATH=$5
XML_QUERY_DIRS=$6
FILE=$7
LOGFILE=$8
LIST=$9


if [ "@$8" == "@" ]
then
	echo Missing PARAM8 LOGFILE
else
if [ "@$7" == "@" ]
then
	echo Missing PARAM7 XML FILE
else
if [ "@$6" == "@" ]
then
	echo Missing PARAM6 DIRS
else
if [ "@$5" == "@" ]
then
	echo Missing PARAM5 XML_QUERY_PATH
else
if [ "@$4" == "@" ]
then
	echo Missing PARAM4 PID
else
if [ "@$3" == "@" ]
then
	echo Missing PARAM3  MFN
else
if [ "@$2" == "@" ]
then
	echo Missing PARAM2 BIB4CIT
else
if [ "@$1" == "@" ]
then
	echo Missing PARAM1 MX

else
	
	if [ ! -f $XML_QUERY_PATH/archive/$FILE ]
	then
		if [ ! -f $XML_QUERY_PATH/sent/$FILE ]
		then
			if [ ! -f $XML_QUERY_PATH/new/$FILE ]
			then
				if [ ! -d $XML_QUERY_PATH/new/$XML_QUERY_DIRS ]
				then
					mkdir -p $XML_QUERY_PATH/new/$XML_QUERY_DIRS
					mkdir -p $XML_QUERY_PATH/sent/$XML_QUERY_DIRS
					mkdir -p $XML_QUERY_PATH/archived/$XML_QUERY_DIRS
				fi
			    sh scripts/reglog.sh $PID new >> $LOGFILE
				$MX $BIB4CIT from=$MFN count=1 gizmo=gizmo/ent gizmo=gizmo/ent2  lw=9999 "pft=@scripts/xml.pft" now > $XML_QUERY_PATH/new/$FILE
				
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

