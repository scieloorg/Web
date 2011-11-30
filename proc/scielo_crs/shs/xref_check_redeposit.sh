. crossref_config.sh
MYXML=$1
PID=$2
logDate=$3
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
if [ -f $MYXML ]
then 
echo Redeposit $MYXML
java -Dfile.encoding=ISO-8859-1 -cp .:$conversor_dir/java/crossrefSubmit.jar:$conversor_dir/java/lib/HTTPClient.jar org.crossref.doUpload $crossrefUserName $crossrefPassword $MYXML $PID $logDate$PID

fi