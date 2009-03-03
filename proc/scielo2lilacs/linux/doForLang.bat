export BATCHES_PATH=scielo2lilacs/linux/

export MX=$MX
export WXIS=$WXIS

export SCIELOLILACS_LOG=$SCIELOLILACS_LOG
export ACRON=$1
export ISSUEID=$2
export FILENAME=$3
export EXTENSION=$4
export OLANG=$5
export DOC_LANG=$6
export DOCPATH=$7
export DOCFORMAT=$8

echo Executing $0 for acron=$ACRON issueid=$ISSUEID filename=$FILENAME docpath=$DOCPATH docformat=$DOCFORMAT olang=$OLANG lang=$DOC_LANG  >> $SCIELOLILACS_LOG

if [ "@$DOCFORMAT" == "@" ]
then
	# EXTENSION IS EXTENSION
	# USE AS PREFIX THE LANG
	if [  "@$OLANG" == "@$DOC_LANG" ]
	then
		echo 
	else
		export f=$DOCPATH/$ACRON/$ISSUEID/$DOC_LANG\_$FILENAME\.$EXTENSION
		echo   Testing 1 "$f"  >> $SCIELOLILACS_LOG
		if [ -f "$f" ]
		then
			echo OK  >> $SCIELOLILACS_LOG
		   $MX temp/scielo2lilacs_AddProc count=1 "proc='a601{^d$DOCPATH/^f$ACRON/$ISSUEID/$DOC_LANG_$FILENAME.$EXTENSION^l$DOC_LANG{'" copy=temp/scielo2lilacs_AddProc now -all
		fi
	fi

else
	# EXTENSION IS DOCFORMAT
	if [ "@$OLANG" == "@$DOC_LANG" ]
	then
		# NO PREFIX OF LANG

		echo   Testing 2 "$DOCPATH/$ACRON/$ISSUEID/$FILENAME.$DOCFORMAT"  >> $SCIELOLILACS_LOG
		if [ -f "$DOCPATH/$ACRON/$ISSUEID/$FILENAME.$DOCFORMAT" ]
		then
			echo OK  >> $SCIELOLILACS_LOG
		   $MX temp/scielo2lilacs_AddProc count=1 "proc='a602{^d$DOCPATH/^f$ACRON/$ISSUEID/$FILENAME.$DOCFORMAT^l$DOC_LANG{'" copy=temp/scielo2lilacs_AddProc now -all
		fi
	else
		# USE AS PREFIX THE LANG
		echo   Testing 3 "$DOCPATH/$ACRON/$ISSUEID/$DOC_LANG_$FILENAME.$DOCFORMAT"  >> $SCIELOLILACS_LOG
		if [ -f "$DOCPATH/$ACRON/$ISSUEID/$DOC_LANG_$FILENAME.$DOCFORMAT" ]
		then
			echo OK  >> $SCIELOLILACS_LOG
		  $MX temp/scielo2lilacs_AddProc count=1 "proc='a602{^d$DOCPATH/^f$ACRON/$ISSUEID/$DOC_LANG_$FILENAME.$DOCFORMAT^l$DOC_LANG{'" copy=temp/scielo2lilacs_AddProc now -all
		 fi
	fi
fi
