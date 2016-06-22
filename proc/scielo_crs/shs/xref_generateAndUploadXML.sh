PID=$1
REPROC=$2
PROCESS_ONLY_NEW=$3

. crossref_config.sh

LOG_PATH=$conversor_dir/output/crossref/log

echo $PID > $MYTEMP/$PID.txt

$cisis_dir/mx "seq=$MYTEMP/$PID.txt" lw=9999 "pft=v1*1.9,'/',v1*10.4,'/',v1*14.4,'/',v1*18" now > $MYTEMP/$PID_path.txt
MYXMLPATH=`cat $MYTEMP/$PID_path.txt`
rm $MYTEMP/$PID_path.txt

$cisis_dir/mx "seq=$MYTEMP/$PID.txt" lw=9999 "pft=v1*18" now > $MYTEMP/$PID_path.txt
MYXML=`cat $MYTEMP/$PID_path.txt`
rm $MYTEMP/$PID_path.txt

logDate=`cat logDate.txt`

MYXMLPATH=$conversor_dir/output/crossref/$MYXMLPATH
MYXML=$MYXMLPATH/requestDOIXML_${MYXML}.xml

if [ ! -d $MYXMLPATH ];
then
    mkdir -p $MYXMLPATH
fi

#    $conversor_dir/shs/xref_evaluateReturn.sh crossref_sent_$logDate$PID.log $PID $PID update-new 
#    $conversor_dir/shs/xref_evaluateReturn.sh validationErrors_$logDate$PID.log $PID $PID error 
#    $conversor_dir/shs/xref_evaluateReturn.sh crossref_sentError_$logDate$PID.log $PID $PID error 

if [ ! -f $MYXML -o  "$REPROC" = "DO" -o ! "$PROCESS_ONLY_NEW" = "DO" ]
then
    $cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB  "btell=0" "hr=$PID" "proc=('G$conversor_dir/gizmo/crossref')" lw=99999 "proc='a9038{$depositor_prefix{a9037{$depositor_url{a9040{$depositor_institution{a9041{$depositor_email{" pft=@$conversor_dir/pft/xref_requestXML.pft "tell=1000" -all now | iconv --from-code=ISO-8859-1 --to-code=UTF-8 > $MYXML

    # xml generation
    xmllint $MYXML --schema $conversor_dir/xsd/${crossref_xsd} --noout &> $LOG_PATH/${PID}_validation.log
    echo >> $LOG_PATH/${PID}_validation.log
    $cisis_dir/mx seq=$LOG_PATH/${PID}_validation.log count=1 "pft=if v1:'validates' then 'valid' else 'invalid xml' fi" now > $MYTEMP/${PID}_validation_status.txt

    VALIDATION_STATUS=`cat $MYTEMP/${PID}_validation_status.txt`
    
    if [ "$VALIDATION_STATUS" = "valid" ]
    then
        rm $MYTEMP/${PID}_validation_status.txt
        rm $LOG_PATH/${PID}_validation.log

        curl -F operation=doQueryUpload -F login_id=$crossrefUserName -F login_passwd=$crossrefPassword -F fname=@$MYXML https://doi.crossref.org/servlet/deposit &> $LOG_PATH/${PID}_submission.log
        $cisis_dir/mx seq=$LOG_PATH/${PID}_submission.log lw=999 "pft=if v1:'SUCCESS' then 'submitted'/ fi" now > $MYTEMP/${PID}_validation_status0.txt
        
        $cisis_dir/mx seq=$MYTEMP/${PID}_validation_status0.txt count=1 "pft=if v1:'submitted' then 'submitted' else 'error' fi" now > $MYTEMP/${PID}_submission_status.txt
        rm $MYTEMP/${PID}_validation_status0.txt

        SUBMISSION_STATUS=`cat $MYTEMP/${PID}_submission_status.txt`
        rm $MYTEMP/${PID}_submission_status.txt

        if [ "$SUBMISSION_STATUS" = "submitted" ]
        then
            mv $LOG_PATH/${PID}_submission.log $LOG_PATH/crossref_sent_$logDate$PID.log
            $conversor_dir/shs/xref_evaluateReturn.sh $LOG_PATH/crossref_sent_$logDate$PID.log $PID OK
        else
            mv $LOG_PATH/${PID}_submission.log $LOG_PATH/crossref_sentError_$logDate$PID.log
            $conversor_dir/shs/xref_evaluateReturn.sh $LOG_PATH/${PID}_submission.log $PID error
        fi
    else
        mv $LOG_PATH/${PID}_validation.log $LOG_PATH/validationErrors_$logDate$PID.log
        $conversor_dir/shs/xref_evaluateReturn.sh $LOG_PATH/validationErrors_$logDate$PID.log $PID error 
    fi
fi

