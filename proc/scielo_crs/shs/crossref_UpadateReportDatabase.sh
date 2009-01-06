##### 
# Gera arquivo XML da bases scielo FRONT/BACK
# Parametros
# $1 - nome da base de dados que será processada

. crossref_config.sh

DATE=`cat logDate.txt`

if [ ! -f ../databases/crossref/crossref_DOIReport.mst ]; then
	$cisis_dir/mx seq=/dev/null create=../databases/crossref/crossref_DOIReport
	$cisis_dir/mx ../databases/crossref/crossref_DOIReport fst=@../databases/crossref/crossref_DOIReport.fst fullinv=../databases/crossref/crossref_DOIReport -all now
fi


#Atualizando base de dados com PID com status new ou update
if [ -f crossref_sent_$DATE.log ]; then
	COUNTY=`grep -cE $ crossref_sent_$DATE.log`
	TOT=$COUNTY
	if [ $COUNTY ]; then 
		echo "TOTAL: "$COUNTY
		while [ $COUNTY != 0 ]
		do
		   DAVEZ_Y=`tail -n $COUNTY crossref_sent_$DATE.log | head -n 1`
		   PID=${DAVEZ_Y:0:23}
		   if [ $PID ]; then
			   echo "${COUNTY} - ${PID}"
			   STATUS=`$cisis_dir/mx ../databases/crossref/crossref_DOIReport "btell=0" "HR=$PID" "pft= mfn(0)" -all now`
			   if [ $STATUS > 0 ]; then
				echo -n "true  [updated] "
			   	$cisis_dir/mx ../databases/crossref/crossref_DOIReport "proc='d10d30a30/update/a10/$DATE/'" copy=../databases/crossref/crossref_DOIReport from=$STATUS count=1 -all now
			   else
				echo -n "false [new one] "
				$cisis_dir/mx null "proc='a30/new/a880/$PID/a10/$DATE/'" append=../databases/crossref/crossref_DOIReport count=1 -all now   
			   fi
		   fi
		   COUNTY=`expr $COUNTY - 1`
		done
	fi
fi

#atualizando base de dados com PID com status de erro de validacao
if [ -f validationErrors_$DATE.log ]; then
	COUNTY=`grep -cE $ validationErrors_$DATE.log`
	TOT=$COUNTY
	
	if [ $COUNTY ]; then
		echo "TOTAL: "$COUNTY
		while [ $COUNTY != 0 ]
		do
		   DAVEZ_Y=`tail -n $COUNTY validationErrors_$DATE.log | head -n 1`
		   PID=${DAVEZ_Y:0:23}
		   if [ $PID ]; then
			   echo "${COUNTY} - ${PID}"
			   STATUS=`$cisis_dir/mx ../databases/crossref/crossref_DOIReport "btell=0" "HR=$PID" "pft= mfn(0)" -all now`
			   if [ $STATUS > 0 ]; then
			        echo -n "true  [new error] "
			        $cisis_dir/mx ../databases/crossref/crossref_DOIReport "proc='d10d30a30/error/a10/$DATE/'" copy=../databases/crossref/crossref_DOIReport from=$STATUS count=1 -all now
			   else
			        echo -n "false [existent error] "
			        $cisis_dir/mx null "proc='a30/error/a880/$PID/a10/$DATE/'" append=../databases/crossref/crossref_DOIReport count=1 -all now
			   fi
		   fi
		   COUNTY=`expr $COUNTY - 1`
		done
	fi
fi
#atualizando base de dados com PID com status de erro de envio
if [ -f crossref_sentError_$DATE.log ]; then
	COUNTY=`grep -cE $ crossref_sentError_$DATE.log`
	TOT=$COUNTY
	
	if [ $COUNTY ]; then
		echo "TOTAL: "$COUNTY
		
		while [ $COUNTY != 0 ]
		do
		   DAVEZ_Y=`tail -n $COUNTY crossref_sentError_$DATE.log | head -n 1`
		   PID=${DAVEZ_Y:0:23}
		   if [ $PID ]; then
			   echo "${COUNTY} - ${PID}"
			   STATUS=`$cisis_dir/mx ../databases/crossref/crossref_DOIReport "btell=0" "HR=$PID" "pft= mfn(0)" -all now`
			   if [ $STATUS > 0 ]; then
			        echo -n "true  [sent error - old rec] "
			        $cisis_dir/mx ../databases/crossref/crossref_DOIReport "proc='d10d30a30/error/a10/$DATE/'" copy=../databases/crossref/crossref_DOIReport from=$STATUS count=1 -all now
			   else
			        echo -n "false [sent error - new rec] "
			        $cisis_dir/mx null "proc='a30/error/a880/$PID/a10/$DATE/'" append=../databases/crossref/crossref_DOIReport count=1 -all now
			   fi
		   fi	
		   COUNTY=`expr $COUNTY - 1`
		done
	fi
fi

$cisis_dir/mx ../databases/crossref/crossref_DOIReport fst=@../databases/crossref/crossref_DOIReport.fst fullinv=../databases/crossref/crossref_DOIReport -all now
