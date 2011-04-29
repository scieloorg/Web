
export PATH=$PATH:.
export CISIS_DIR=cisis

rem parametro 1 QUERY_ID
rem parametro 2 PROCESS_DATE

rem parametro 3 DIR_XML
rem parametro 4 BASE_VN_DOI
rem parametro 5 BASE_REGBIBLIO

rem parametro 6 EMAIL
rem parametro 7 USER
rem parametro 8 PASSWORD

rem parametro 9 pid list

echo Execution begin of $0 $1 $2 $3 $4 $5 $6 $7 $8 $9  in  `date`

QUERY_ID=$1


DIR_XML=$3

BASE_VN_DOI=$4
BASE_REGBIBLIO=$5

EMAIL=$6
USER=$7
PASSWORD=$8
PROCESS_DATE=$2

DOI_LIST_FILE=temp/doi/proc/current/$QUERY_ID.seq

QUERY_FILE=$DIR_XML/query_$QUERY_ID.xml
QUERY_RESULT_FILE=$DIR_XML/qr_$QUERY_ID.xml
PID_LIST=$9

if grep -q "S" $PID_LIST
then
	cisis/mx seq=$PID_LIST lw=9999 "pft=if l(['$BASE_VN_DOI'],v1)=0 then v1/ fi" now> temp/doi/proc/current/create_pid_list.txt
	if [ -f temp/doi/proc/current/create_pid_list.txt ]
	then 
		echo create records...
		cisis/mx seq=temp/doi/proc/current/create_pid_list.txt lw=9999 "pft=if v1<>'' then 'doi/create_update/CreateOrUpdate.bat $BASE_VN_DOI ',v1,' ',if a(v2) then 'x' else v2 fi,' unknow query append'/, fi" now > temp/doi/proc/current/CreateOrUpdate.bat
		chmod 770 temp/doi/proc/current/CreateOrUpdate.bat
		call temp/doi/proc/current/CreateOrUpdate.bat
		cisis/mx $BASE_VN_DOI fst=@doi/fst/doi.fst fullinv=$BASE_VN_DOI
	fi


	echo Execute query
	doi/batch/DOI_Step2_GenerateQueryXML.bat $QUERY_FILE $EMAIL $BASE_REGBIBLIO $PID_LIST

	cd doi/crossref
	./CrossRefQuery.bat -f ../../$QUERY_FILE -r xml -u $USER -p $PASSWORD -a live >& ../../$QUERY_RESULT_FILE
	cd ../../

	rm $DIR_XML/notxml/query_$QUERY_ID.xml $DIR_XML/notxml/qr_$QUERY_ID.xml $DIR_XML/malformed/query_$QUERY_ID.xml $DIR_XML/malformed/qr_$QUERY_ID.xml

	if grep -q "<?xml" $QUERY_RESULT_FILE
	then
		if grep -q "malformed" $QUERY_RESULT_FILE
		then
			echo malformed
			export STATUS_RESULT=malformed
			call batch/CriaDiretorio.bat $DIR_XML/malformed
			mv $QUERY_RESULT_FILE $DIR_XML/malformed
			mv $QUERY_FILE $DIR_XML/malformed
		else
			echo Extract result

			call doi/batch/DOI_Step4_ExtractResultFromXML.bat $QUERY_RESULT_FILE $DOI_LIST_FILE $QUERY_ID

			
			cisis/mx seq=$DOI_LIST_FILE lw=9999 "pft=if l(['$BASE_VN_DOI'],v1)>0  then 'doi/create_update/CreateOrUpdate.bat $BASE_VN_DOI ',v1,' ',if a(v2) then 'x' else v2 fi,' ',v3,' query copy'/, fi" now > temp/doi/proc/current/CreateOrUpdate.bat

			chmod 770 temp/doi/proc/current/CreateOrUpdate.bat
			call temp/doi/proc/current/CreateOrUpdate.bat
			rem rm $QUERY_FILE $QUERY_RESULT_FILE
		fi
	else
		echo ERROR - NOT XML!
		export STATUS_RESULT=notxml
		call batch/CriaDiretorio.bat $DIR_XML/notxml
		mv $QUERY_RESULT_FILE $DIR_XML/notxml
		mv $QUERY_FILE $DIR_XML/notxml
	fi
else 
	echo Nothing to do
fi
echo Execution end of $0 $1 $2 $3 $4 $5 $6 $7 $8 $9  in  `date`
