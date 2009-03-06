export SCILIL_LIST_VALID_LIST=$1
export SCILIL_LIST_SRCDB=$2
export SCILIL_LIST_DBRESULT=$3


export SCILIL_LIST_CTRL_CONVERSION=$4
export SCILIL_LIST_CTRL_ISSUE=$5
export SCILIL_LIST_CF=$6
export SCILIL_LIST_WXISLOG=$7
export SCILIL_LIST_DBLANG=$8
export debug=$9


if [ -f "$SCILIL_LIST_VALID_LIST" ]
then

	if [ -f "$SCILIL_GBL_SCIELOTP.mst" ]
	then
		if [ -f "$SCILIL_GBL_GIZMOA.mst" ]
		then
			if [ -f "$SCILIL_GBL_LILTITLE.mst" ]
			then

				if [ -f "$SCILIL_LIST_DBLANG.mst" ]
				then

					if [ -f "$SCILIL_LIST_SRCDB.mst" ]
					then
						if [ "@$debug" == "@On" ]
						then
							echo Enter to check the list or CTRL+C to end
							read
							vi $SCILIL_LIST_VALID_LIST
							echo Enter to continue or CTRL+C to end
							read
						fi
						if [ ! -f "$SCILIL_LIST_CTRL_ISSUE.mst" ]
						then
							$SCILIL_MX null count=0 create=$SCILIL_LIST_CTRL_ISSUE now -all
						fi
						scielo2lilacs/linux/invert.bat $SCILIL_MX $SCILIL_LIST_CTRL_ISSUE scielo2lilacs/fst/ctrl_issue.fst
						if [ ! -f "$SCILIL_LIST_CTRL_CONVERSION.mst" ]
						then
							$SCILIL_MX null count=0 create=$SCILIL_LIST_CTRL_CONVERSION now -all
						fi
						scielo2lilacs/linux/invert.bat $SCILIL_MX $SCILIL_LIST_CTRL_CONVERSION scielo2lilacs/fst/ctrl_conversion.fst
						chmod -R 774 $SCILIL_LIST_CTRL_CONVERSION.* $SCILIL_LIST_CTRL_ISSUE.*


						if [ -f $SCILIL_LIST_DBRESULT.mst ] 
						then
							$SCILIL_MX "seq=$SCILIL_LIST_VALID_LIST " lw=9999 "pft=if p(v1)  then 'scielo2lilacs/linux/deleteRecordsDBResult.bat $SCILIL_MX $SCILIL_LIST_DBRESULT ',v3,' '/ fi" now> temp/scielo2lilacs_deleteRecordsDBResult.bat
							chmod 775 temp/scielo2lilacs_deleteRecordsDBResult.bat

							echo Executara 
							#more temp/scielo2lilacs_deleteRecordsDBResult.bat
							
							temp/scielo2lilacs_deleteRecordsDBResult.bat
							$SCILIL_MX null count=0 create=$SCILIL_LIST_DBRESULT now -all
							$SCILIL_MX temp/scielo2lilacs_DBRESULT append=$SCILIL_LIST_DBRESULT now -all

						else
							$SCILIL_MX null count=1 create=$SCILIL_LIST_DBRESULT now -all 			
						fi
						scielo2lilacs/linux/invert.bat $SCILIL_MX $SCILIL_LIST_DBRESULT scielo2lilacs/fst/dbresult.fst
											
						$SCILIL_MX "seq=$SCILIL_LIST_VALID_LIST " lw=9999 "pft=if p(v3) then 'scielo2lilacs/linux/doForIssue.bat $SCILIL_LIST_SRCDB $SCILIL_LIST_DBRESULT ',v3,' ',v1,' ',v5,' $SCILIL_LIST_WXISLOG $SCILIL_LIST_CF $SCILIL_LIST_CTRL_CONVERSION '/ fi" now> temp/scielo2lilacs_DoForIssue.bat

						chmod 775 temp/scielo2lilacs_DoForIssue.bat
	echo Executing temp/scielo2lilacs_DoForIssue.bat


						temp/scielo2lilacs_DoForIssue.bat
						
						# scielo2lilacs/linux/invert.bat $SCILIL_MX $SCILIL_LIST_DBRESULT scielo2lilacs/fst/dbresult.fst
						# scielo2lilacs/linux/invert.bat $SCILIL_MX $SCILIL_LIST_CTRL_CONVERSION scielo2lilacs/fst/ctrl_conversion.fst
						 scielo2lilacs/linux/invert.bat $SCILIL_MX $SCILIL_LIST_CTRL_ISSUE scielo2lilacs/fst/ctrl_issue.fst
					else
						echo Missing $SCILIL_LIST_SRCDB
					fi
				else
					echo Missing $SCILIL_LIST_DBLANG
				fi
			else
				echo Missing $SCILIL_GBL_LILTITLE
			fi
		else
			echo Missing $SCILIL_GBL_GIZMOA
		fi
	else
		echo Missing $SCILIL_GBL_SCIELOTP
	fi
else
	echo Missing $SCILIL_LIST_VALID_LIST
fi
