PID=$1
REPROC=$2
PROCESS_ONLY_NEW=$3

. crossref_config.sh

echo $PID > $MYTEMP/$PID.txt

$cisis_dir/mx "seq=$MYTEMP/$PID.txt" lw=9999 "pft='../output/crossref/',v1*1.9,'/',right(s('00000',v1*10.4),4),'/',right(s('00000',v1*14.4),4),'/',right(s('00000',v1*19.5),5)" now > $MYTEMP/$PID_path.txt
MYXMLPATH=`cat $MYTEMP/$PID_path.txt`
rm $MYTEMP/$PID_path.txt

$cisis_dir/mx "seq=$MYTEMP/$PID.txt" lw=9999 "pft='../output/crossref/',v1*1.9,'/',right(s('00000',v1*10.4),4),'/',right(s('00000',v1*14.4),4),'/',right(s('00000',v1*19.5),5),'/requestDOIXML_',right(s('00000',v1*19.5),5),'.xml'" now > $MYTEMP/$PID_path.txt
MYXML=`cat $MYTEMP/$PID_path.txt`


rm $MYTEMP/$PID_path.txt
rm $MYTEMP/$PID.txt

logDate=`cat logDate.txt`

if [ ! -d $MYXMLPATH ];
then
	mkdir -p $MYXMLPATH
fi

if [ ! -f $MYXML -o  "$REPROC" = "DO" -o ! "$PROCESS_ONLY_NEW" = "DO" ]
then

	$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB  "btell=0" "hr=$PID" "proc=('G$conversor_dir/gizmo/crossref')" lw=99999 "proc='a9038{$depositor_prefix{a9037{$depositor_url{a9040{$depositor_institution{a9041{$depositor_email{" pft=@$conversor_dir/pft/xref_requestXML.pft "tell=1000" -all now | iconv --from-code=ISO-8859-1 --to-code=UTF-8 > $MYXML


	# $JAVA_HOME/bin/java -Dfile.encoding=ISO-8859-1 -cp .:$conversor_dir/java/crossrefSubmit.jar:$conversor_dir/java/lib/HTTPClient.jar org.crossref.doUpload $crossrefUserName $crossrefPassword $MYXML $PID $logDate 

	if [ -f crossref_sent_$logDate$PID.log ]
	then 
		rm crossref_sent_$logDate$PID.log
	fi
	if [ -f validationErrors_$logDate$PID.log ]
	then 
		rm validationErrors_$logDate$PID.log
	fi
	if [ -f crossref_sentError_$logDate$PID.log ]
	then 
		rm crossref_sentError_$logDate$PID.log
	fi

	$JAVA_HOME/bin/java -Dfile.encoding=ISO-8859-1 -cp .:$conversor_dir/java/crossrefSubmit.jar:$conversor_dir/java/lib/HTTPClient.jar org.crossref.doUpload $crossrefUserName $crossrefPassword $MYXML $PID $logDate$PID

	#Atualizando base de dados com PID com status new ou update or error
	$conversor_dir/shs/xref_evaluateReturn.sh crossref_sent_$logDate$PID.log $PID $PID update-new 
	$conversor_dir/shs/xref_evaluateReturn.sh validationErrors_$logDate$PID.log $PID $PID error 
	$conversor_dir/shs/xref_evaluateReturn.sh crossref_sentError_$logDate$PID.log $PID $PID error 

fi

