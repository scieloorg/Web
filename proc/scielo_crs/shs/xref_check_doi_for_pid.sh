. crossref_config.sh

PID=$1
DEPOSIT_XML_FILE=$2
LOG_FILE=$3
NEW_DB_DOI=$4
PID_881=$5
XML_881=$6
PID_891=$7
XML_891=$8

MX=$cisis_dir/mx
ANS_FILE=$MYTEMP/DOI_CHECK_$PID
QUERY_XML_FILE=$ANS_FILE.xml
QUERY_RESULT=$ANS_FILE.res
PFT_PATH=../pft

echo ... check doi for $PID

echo >$ANS_FILE

#### QUERY CROSSREF ####
echo ... query crossref
# do query at CrossRef
$MX null count=1 "proc='a9000{$depositor_email{a9001{$PID','-',replace(date,' ','-'),'{'"  lw=999 "pft=@$PFT_PATH/begin.pft" now > $QUERY_XML_FILE
$MX $ARTIGO_DB btell=0 "hr=$PID" gizmo=../gizmo/ent gizmo=../gizmo/ent2 lw=9999 "pft=@$PFT_PATH/xml.pft" now >> $QUERY_XML_FILE
$MX null count=1 lw=999 "pft=@$PFT_PATH/end.pft" now >> $QUERY_XML_FILE

cd $conversor_dir/crossref
echo sh ./CrossRefQuery.sh -f $QUERY_XML_FILE -t d -a live -u $crossrefUserName -p $crossrefPassword -r piped > $QUERY_RESULT

sh ./CrossRefQuery.sh -f $QUERY_XML_FILE -t d -a live -u $crossrefUserName -p $crossrefPassword -r piped > $QUERY_RESULT
cd ../shs

more $QUERY_RESULT
$MX seq=$QUERY_RESULT "pft=if size(v9)>0 then if v9*0.1='S' and v10:'/' and not v10:'---' then v10   fi  fi" now  > $ANS_FILE

#### FIM QUERY CROSSREF ####

DOI_OR_NO=`cat $ANS_FILE`
if [ "@$DOI_OR_NO" == "@" ]
then 
   
    if [ "@$DEPOSIT_XML_FILE" != "@" ]
    then 
      	if [ -f $DEPOSIT_XML_FILE ]
      	then
      		sh ./xref_check_redeposit.sh $DEPOSIT_XML_FILE $PID
        	echo $PID redeposit >> $LOG_FILE
      	fi
    else
    	echo Missing $DEPOSIT_XML_FILE 
	    if [ "@$XML_881" != "@" ]
	    then 
	      	if [ -f $XML_881 ]
	      	then
	      		sh ./xref_check_redeposit.sh $XML_881 $PID
	        	echo $PID redeposit >> $LOG_FILE
	      	fi
	    else
	    	echo Missing $XML_881 
	    	if [ "@$XML_891" != "@" ]
		    then 
		      	if [ -f $XML_891 ]
		      	then
		      		sh ./xref_check_redeposit.sh $XML_891 $PID
		        	echo $PID redeposit >> $LOG_FILE
		      	fi
		    else
		    	echo $PID new >> $LOG_FILE
		    	echo Missing $XML_891 
		    fi
		    
	    fi
	    
    	
    fi
else 
    echo $PID crossref >> $LOG_FILE
    $cisis_dir/mx $NEW_DB_DOI btell=0 "bool=PID=$PID" lw=9999 "proc=if v880='$PID' or v881='$PID' or v891='$PID' and '$DOI_OR_NO'<>''  then 'd237a237{$DOI_OR_NO{','a91{',date,'{' fi" copy=$NEW_DB_DOI now -all
fi
if [ "@$PID" != "@" ]
then
    rm ${ANS_FILE}*
fi