# Param 1 issn
# Param 2 count

# export MX=$MX
# CPFILE
#
export PROCESS_DATE=`date +%Y%m%d`

export MX=$1
export CPFILE=$2
export JOURNAL_EDBOARD_HTML_PATH=$3
export ACRON=$4
export FILENAME=iedboard.htm

export OUTPUT_PATH=$5
export REL_OUTPUT_PATH=$6
export HTML_FILE_OUTPUT=$7
export JournalFile=$HTML_FILE_OUTPUT

# $MX "seq=$JOURNAL_EDBOARD_HTML_PATH/$ACRON/$FILENAME¨" lw=999999 "pft=if (v1:'<li>' or v1:'</li>') and not v1:'<a href' then replace(replace( replace(v1,'<',s(#,'<')) ,'>',s('>',#)),'  ',' ')  fi" now> $OUTPUT_PATH/$ACRON/edboard.tmp
# echo avaliacao/gizmo/tabEdboard 
# $MX "seq=$OUTPUT_PATH/$ACRON/edboard.tmp¨" lw=999999 gizmo=avaliacao/gizmo/tabEdboard "pft=if p(v1) and size(v1)>2 then v1/ fi" now>  $OUTPUT_PATH/$ACRON/edboard.txt

if [ -f $JOURNAL_EDBOARD_HTML_PATH/$ACRON/$FILENAME ]
then
	$MX "seq=$JOURNAL_EDBOARD_HTML_PATH/$ACRON/$FILENAME¨" lw=999999 "pft=if v1:'<' or v1:'>' then replace(replace( replace(v1,'<',s(#,'<')) ,'>',s('>',#)),'  ',' ') fi" now> $OUTPUT_PATH/$ACRON/edboard.tmp

	$MX "seq=$OUTPUT_PATH/$ACRON/edboard.tmp¨" lw=999999 gizmo=avaliacao/gizmo/tabEdboard "pft=if v1:'<' or v1:'>' then ,else v1/ fi" now>  $OUTPUT_PATH/$ACRON/edboard.txt
	echo $ACRON CORPO EDITORIAL >> $JournalFile
	more $OUTPUT_PATH/$ACRON/edboard.txt >> $JournalFile

fi



