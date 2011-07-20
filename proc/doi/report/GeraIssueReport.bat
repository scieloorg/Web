rem export PATH=$PATH:.
rem GeraIssueDOI
rem Parametro 1: sigla da revista
rem Parametro 2: volume-numero do issue
rem Parametro 3: resultado
rem Parametro 4: formato xml ou seq
rem Parametro 5: selecao de registros por status doi not_doi all
rem Parametro 5: selecao de registros por tipo art ou ref 



echo Execution begin of $0 $1 $2 $3 $4 $5 $6 in  `date`
call batch/InformaLog.bat $0 x Gera ISSUE_DOI DOI: $2 $3

call batch/VerifPresencaParametro.bat $0 @$1 sigla da revista
call batch/VerifPresencaParametro.bat $0 @$2 volume-numero do issue
call batch/VerifPresencaParametro.bat $0 @$3 resultado
call batch/VerifPresencaParametro.bat $0 @$4 formato xml ou seq
call batch/VerifPresencaParametro.bat $0 @$5 selecao de registros por status doi not_doi all

export ISSUE_DOI=../bases-work/doi/$1/$2/$2
export REVISTA=../bases-work/$1/$1
export PROCESS_DATE=`date +%Y%m%d%H%M%S`

if [ $5 == "doi" ]
then
	if [ $6 = "art" ]
	then 
		export EXPRESSION="status=doi and type=art"
	else
		if [ $6 = "ref" ]
		then 
			export EXPRESSION="status=doi and type=ref"
		else
			
			export EXPRESSION="status=doi"
		fi
	fi
else	
	if [ $5 == "not_doi" ]
	then
		if [ $6 = "art" ]
		then 
			export EXPRESSION="type=art and not (status=doi)"
		else
			if [ $6 = "ref" ]
			then 
				export EXPRESSION="type=ref and not (status=doi)"
			else
				export EXPRESSION="$ and not (status=doi)"
			fi
		fi
	else	
		if [ $6 = "art" ]
		then 
			export EXPRESSION="type=art"
		else
			if [ $6 = "ref" ]
			then 
				export EXPRESSION="type=ref"
			else
				export EXPRESSION=$
			fi
		fi
		
	fi
fi
if [ $4 == "xml" ]
then
	echo "<issue id=\"$1_$2\">" >> $3
	echo "<expression>$EXPRESSION</expression>" >> $3
	if [ -f "$ISSUE_DOI.xrf" ]
	then
		echo cisis/mx $ISSUE_DOI btell=0 lw=9000 "bool=$EXPRESSION"
		cisis/mx $ISSUE_DOI fst=@doi/fst/doi.fst fullinv=$ISSUE_DOI
		cisis/mx $ISSUE_DOI btell=0 lw=9000 "bool=$EXPRESSION" "pft=@doi/pft/report_in_xml.pft" now >> $3
	else 
		echo "<message type=\"warning\">$ISSUE_DOI does not exist</message>" >> $3
	fi
	echo "</issue>" >> $3
else
	if [ -f "$ISSUE_DOI.xrf" ]
	then
		cisis/mx $ISSUE_DOI btell=0 lw=9000 "bool=$EXPRESSION" "proc='d9000d9001a9000{$1{a9001{$2{'" "pft=@doi/pft/report_in_seq.pft" now >> $3
	else 
		echo WARNING: $ISSUE_DOI does not exist  >> $3
	fi
fi

    
echo Execution end of $0 $1 $2 $3 $4 $5 $6 in  `date`
