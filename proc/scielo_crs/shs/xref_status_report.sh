

. crossref_config.sh

./xref_status_report_db.sh

if [ -f $XREF_DB_PATH/xref_status_report.mst ];
then

	REPORT_PATH=$conversor_dir/output/status
	PREVIOUS_REPORT_PATH=$conversor_dir/output/status_previous
	
    if [ -d $PREVIOUS_REPORT_PATH ];
    then
    	rm -rf $PREVIOUS_REPORT_PATH
	fi
	if [ -d $REPORT_PATH ];
    then
    	mv $REPORT_PATH $PREVIOUS_REPORT_PATH
	fi
	mkdir -p $REPORT_PATH

	echo Generating Reports

	# ERROS DE XML AO DEPOSITAR
	echo -e "Report: Deposit Errors - XML\n\n" > ${REPORT_PATH}/deposit_error_xml.csv
	echo -e "Article failed to deposit because of XML\tlog" >> ${REPORT_PATH}/deposit_error_xml.csv
	$cisis_dir/mx btell=0 $XREF_DB_PATH/xref_status_report "ERRTYPE=xml error" lw=999 "pft=v1,x9,v5/" now | sort >> ${REPORT_PATH}/deposit_error_xml.csv

	# ERROS DE CONEXAO AO DEPOSITAR
	echo -e "Report: Deposit Errors - Submission\n\n" > ${REPORT_PATH}/deposit_error_xml.csv
	echo -e "Article failed to submit\tlog" >> ${REPORT_PATH}/deposit_error_submission.csv
	$cisis_dir/mx btell=0 $XREF_DB_PATH/xref_status_report "ERRTYPE=submission error" lw=999 "pft=v1,x9,v5/" now | sort >> ${REPORT_PATH}/deposit_error_submission.csv

	# ESTIMATED FUTURE EXPENSES
	echo -e "Report: Estimated future expenses\n\n" > ${REPORT_PATH}/estimated_future_expenses.csv
	echo -e "Articles never deposited\tPublication Date\t(Estimated) Deposit date\t(Estimated) Price" >> ${REPORT_PATH}/estimated_future_expenses.csv
	$cisis_dir/mx btell=0  $XREF_DB_PATH/xref_status_report "ESTIMDATETP=estimative" lw=999 "pft=v1,x9,v2,x9,v11,x9,v12/" now | sort >> ${REPORT_PATH}/estimated_future_expenses.csv

	# ESTIMATED (PAST) EXPENSES
	echo -e "Report: Estimated (past) expenses\n\n" > ${REPORT_PATH}/estimated_past_expenses.csv
	echo -e "Articles deposited\tDeposit date\tEstimated Price\tPrice type" >> ${REPORT_PATH}/estimated_past_expenses.csv
	$cisis_dir/mx btell=0 $XREF_DB_PATH/xref_status_report "$ and not ( ESTIMDATETP=deposit )" lw=999 "pft=v1,x9,v11,x9,v12,x9,v13/" now | sort >> ${REPORT_PATH}/estimated_past_expenses.csv

	# REGISTERED (PAST) EXPENSES
	echo -e "Report: Registered (past) expenses\n\n" > ${REPORT_PATH}/registered_expenses.csv
	echo -e "Articles deposited\tDeposit date\tPrice" >> ${REPORT_PATH}/registered_expenses.csv
	$cisis_dir/mx btell=0 $XREF_DB_PATH/xref_status_report "ESTIMDATETP=deposit" lw=999 "pft=v1,x9,v11,x9,v12/" now | sort >> ${REPORT_PATH}/registered_expenses.csv

	# ALL (PAST) EXPENSES
	echo -e "Report: All (past) expenses\n\n" > ${REPORT_PATH}/estimated_and_registered_expenses.csv
	echo -e "Articles deposited\tDeposit date\tPrice\tPrice type" >> ${REPORT_PATH}/estimated_and_registered_expenses.csv
	$cisis_dir/mx btell=0 $XREF_DB_PATH/xref_status_report "ESTIMDATETP=$" lw=999 "pft=v1,x9,v11,x9,v12,x9,v13/" now | sort >> ${REPORT_PATH}/estimated_and_registered_expenses.csv

	# Deposited but not displayed
    echo -e "Report: Deposited but not displayed\n\n" > ${REPORT_PATH}/deposited_but_not_displayed.csv
	echo -e "DOI deposited but not displayed" >> ${REPORT_PATH}/deposited_but_not_displayed.csv
	$cisis_dir/mx btell=0 $XREF_DB_PATH/xref_status_report "( DEPOSIT_STATUS=new or DEPOSIT_STATUS=update ) and not ( DISPLAY_DOI=$ )" lw=999 "pft=v1/" now | sort >> ${REPORT_PATH}/deposited_but_not_displayed.csv

	#1 0 mpl,'PID='v1
	#2 0 mpl,'PUBDATE='v2
	#3 0 mpl,'DEPOSIT_DATE='v3
	#4 0 mpl,'DEPOSIT_STATUS='v4
	#6 0 mpl,'ERRTYPE='v6
	#7 0 mpl,'BILL_DATE='v7
	#8 0 mpl,'BILL_PRICE='v8
	#9 0 mpl,'DISPLAY_DATE='v9
	#10 0 mpl,'DISPLAY_DOI='v10
	#11 0 mpl,'ESTIMDATE='v11
	#12 0 mpl,'ESTIMPRICE='v12
	#13 0 mpl,'ESTIMDATETP='v13

	# Inconsistence displayed but not deposited
	echo -e "Report: Inconsistence displayed but not deposited\n\n" > ${REPORT_PATH}/inconsistence_displayed_but_not_deposited.csv
	echo -e "DOI displayed but not deposited\tPubDate\tDeposit Date\tDeposit Status\tLog\tError Type\tDisplay date\tDisplay DOI\tPrice Date\tPrice value\tPrice type" >> ${REPORT_PATH}/inconsistence_displayed_but_not_deposited.csv
	$cisis_dir/mx btell=0 $XREF_DB_PATH/xref_status_report "DEPOSIT_STATUS=error and DISPLAY_DOI=$" lw=999 "pft=v1,x9,v2,x9,v3,x9,v4,x9,v5,x9,v6,x9,v9,x9,v10,x9,v11,x9,v12,x9,v13/" now | sort >> ${REPORT_PATH}/inconsistence_displayed_but_not_deposited.csv

	ls -lthr ${REPORT_PATH}
	echo "---"
	echo Reports at ${REPORT_PATH}

fi
echo END
