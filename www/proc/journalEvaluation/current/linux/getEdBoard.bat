# obtem o conteudo da pagina secundaria com os dados de editores
. $1

ACRON=$2
OUTPUT_EDBOARD=$3

PROCESS_DATE=`date +%Y%m%d`
FILENAME=iedboard.htm

if [ -f $JOURNAL_EDBOARD_HTML_PATH/$ACRON/$FILENAME ]
then
	$MX "seq=$JOURNAL_EDBOARD_HTML_PATH/$ACRON/$FILENAME¨" lw=999999 "pft=if v1:'<' or v1:'>' then replace(replace( replace(v1,'<',s(#,'<')) ,'>',s('>',#)),'  ',' ') fi" now> $OUTPUT_PATH/$ACRON/edboard.tmp
	$MX "seq=$OUTPUT_EDBOARD.tmp¨" lw=999999 gizmo=$PATH_GZM/tabEdboard "pft=if v1:'<' or v1:'>' then ,else v1/ fi" now>  $OUTPUT_EDBOARD
	
fi


