d=`date '+%Y%m%d-%H%M%S'`

# parametros
SIMULTANEO=YES|NO
COLLECTION=scl
USERNAME=bireme
PASSWORD=p@s5w0Rd
EMAIL=roberta.takenaka@scielo.org
MAXREF=10

# paths
PATH_DATA=/bases/scl.000/proc/scielo_crs/xref_query/data
PATH_RESULT=$PATH_DATA/res
PATH_TEMP=$PATH_DATA/temp
XML_QUERY_PATH=$PATH_DATA/xml
PATH_NEW=$XML_QUERY_PATH/new
PATH_TEMP=$PATH_DATA/temp
PATH_XML=$XML_QUERY_PATH
PATH_NOHUP=$PATH_DATA/nohup

# bases e arquivos
BIB4CIT=$PATH_DATA/db/bib4cit
PATH_DBQUERY=/bases/scl.000/bases-work/doi/
DBQUERY_NAME=query

SCRIPT_GEN_NEW=$PATH_TEMP/new_xml.$d.sh
LOGFILE_XML=$PATH_DATA/log/xml.$d.log
LOGFILE_QUERY=$PATH_DATA/log/query.$d.log
LOGFILE_RES=$PATH_DATA/log/result.$d.log

NOHUP_XML=$PATH_DATA/log/nohup.$d.xml.out
NOHUP_QUERY=$PATH_DATA/log/nohup.$d.q.out
NOHUP_RES=$PATH_DATA/log/nohup.$d.res.out

# parametros do sistema
MX=mx
PATH_CROSSREF=/bases/scl.000/proc/scielo_crs/crossref/


if [ ! -d $PATH_DATA ]
then
	mkdir -p PATH_DATA
fi
if [ ! -d $PATH_TEMP ]
then
	mkdir -p PATH_TEMP
fi 



if [ "@$SIMULTANEO" == "@YES" ]
then
    nohup sh scripts/run_genxml.sh $MX $SCRIPT_GEN_NEW $BIB4CIT $XML_QUERY_PATH $LOGFILE_XML 2>&1 $NOHUP_XML&
else
    sh scripts/run_genxml.sh $MX $SCRIPT_GEN_NEW $BIB4CIT $XML_QUERY_PATH $LOGFILE_XML
fi




if [ "@$SIMULTANEO" == "@YES" ]
then
    nohup sh scripts/run_query.sh $PATH_CROSSREF $USERNAME $PASSWORD $EMAIL $PATH_NEW  $PATH_TEMP $MAXREF $LOGFILE_QUERY $PATH_RESULT 2>&1 $NOHUP_QUERY&
else
    sh scripts/run_query.sh $PATH_CROSSREF $USERNAME $PASSWORD $EMAIL $PATH_NEW  $PATH_TEMP $MAXREF $LOGFILE_QUERY $PATH_RESULT
fi



if [ "@$SIMULTANEO" == "@YES" ]
then
    nohup sh scripts/run_result.sh $MX $PATH_RESULT  $PATH_TEMP $PATH_DBQUERY $DBQUERY_NAME $LOGFILE_RES  $COLLECTION $PATH_XML 2>&1 $NOHUP_RES&
else
    sh scripts/run_result.sh $MX $PATH_RESULT  $PATH_TEMP $PATH_DBQUERY $DBQUERY_NAME $LOGFILE_RES  $COLLECTION $PATH_XML 
fi
