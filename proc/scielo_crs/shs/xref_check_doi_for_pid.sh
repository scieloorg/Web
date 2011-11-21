. crossref_config.sh

PID=$1
DEPOSIT_XML_FILE=$2
PID_LIST_TO_REPROC_DOI=$3
SCRIPT_TO_REPROC=$4
LOG_FILE=$5
NEW_DB_DOI=$6

MX=$cisis_dir/mx
ANS_FILE=$MYTEMP/DOI_CHECK_$PID
QUERY_XML_FILE=$ANS_FILE.xml
QUERY_RESULT=$ANS_FILE.res
PFT_PATH=../pft

echo "no"  > $ANS_FILE 
DOI_OR_NO=`cat $ANS_FILE`
if [ "@$DOI_OR_NO" == "@no" ]
then 
    # do query at CrossRef
    $MX null count=1 "proc='a9000{$depositor_email{a9001{$PID','-',replace(date,' ','-'),'{'"  lw=999 "pft=@$PFT_PATH/begin.pft" now > $QUERY_XML_FILE
	$MX $ARTIGO_DB btell=0 "hr=$PID" gizmo=../gizmo/ent gizmo=../gizmo/ent2 lw=9999 "pft=@$PFT_PATH/xml.pft" now >> $QUERY_XML_FILE
    $MX null count=1 lw=999 "pft=@$PFT_PATH/end.pft" now >> $QUERY_XML_FILE

    cd $conversor_dir/crossref
    sh ./CrossRefQuery.sh -f $QUERY_XML_FILE -t d -a live -u $crossrefUserName -p $crossrefPassword -r piped >> $QUERY_RESULT
    cd ../shs
    $MX seq=$QUERY_RESULT "pft=if v9*3.1='S' then if v10:'/' and not v10:'---' then v10 else 'no'   fi else 'no'  fi" now  > $ANS_FILE
	DOI_OR_NO=`cat $ANS_FILE`
else
    echo $PID doi_query >> $LOG_FILE
fi
if [ "@$DOI_OR_NO" == "@no" ]
then 
    echo $PID >> $PID_LIST_TO_REPROC_DOI
    if [ "@$DEPOSIT_XML_FILE" != "@" ]
    then 
      if [ -f $DEPOSIT_XML_FILE ]
      then
        echo sh ./xref_check_redeposit.sh $DEPOSIT_XML_FILE $PID >> $SCRIPT_TO_REPROC
        echo $PID reprocdoi >> $LOG_FILE
      fi
    fi
else 
    echo $PID crossref >> $LOG_FILE
fi
if [ "@$DOI_OR_NO" != "@no" ]
then 
    $cisis_dir/mx $NEW_DB_DOI btell=0 "bool=hr=$PID" lw=9999 "proc=if v880='$PID' then 'd237a237{$DOI_OR_NO','^d',date,'{' fi" copy=$NEW_DB_DOI now -all
fi