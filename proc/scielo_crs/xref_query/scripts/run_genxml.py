
MX=$1
SCRIPT_GEN_NEW=$2
BIB4CIT=$3
XML_QUERY_PATH=$4
LOGFILE=$5

if [ "@$5" == "@" ]
then
    echo Missing PARAM5 LOGFILE
else
if [ "@$4" == "@" ]
then
    echo Missing PARAM4 XML_QUERY_PATH
else
    if [ "@$3" == "@" ]
    then 
		echo Missing PARAM3 BIB4CIT
    else
	    if [ "@$2" == "@" ]
	    then 
			echo Missing PARAM2 SCRIPT_GEN_NEW
	    else
		    if [ "@$1" == "@" ]
		    then 
				echo Missing PARAM1 MX
		    else
		        sh scripts/reglog.sh Generating script to generate new XML files >> $LOGFILE
		    	$MX $BIB4CIT lw=9999 "pft=if size(v880)=28 then 'sh scripts/genxml.sh $MX $BIB4CIT ',mfn,' ',v880,' $XML_QUERY_PATH ',v880*1.9,'/',v880*10.4,'/',v880*14.4,'/',v880*18.4,' query_',v880,'.xml $LOGFILE',# fi" now > $SCRIPT_GEN_NEW
                if [ -f $SCRIPT_GEN_NEW ]
                then
                	sh scripts/reglog.sh Generating new XML files >> $LOGFILE
                    sh $SCRIPT_GEN_NEW
                    sh scripts/reglog.sh Finished Generating new XML files >> $LOGFILE
                fi
		    fi
	    fi
    fi
fi
fi
