# obtem o conteudo da pagina secundaria com os dados de editores
echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5
. $1

ACRON=$2
OUTPUT_EDBOARD=$3

PROCESS_DATE=`date +%Y%m%d`
FILENAME=iedboard.htm

if [ -f $JOURNAL_EDBOARD_HTML_PATH/$ACRON/$FILENAME ]
then
	$MX "seq=$JOURNAL_EDBOARD_HTML_PATH/$ACRON/$FILENAME¨" lw=999999 "pft=if v1:'<' or v1:'>' then replace(replace( replace(v1,'<',s(#,'<')) ,'>',s('>',#)),'  ',' ') fi" now> $OUTPUT_EDBOARD.tmp
	$MX "seq=$OUTPUT_EDBOARD.tmp¨" lw=999999 gizmo=$GZM_PIPE2TAB "pft=if v1:'<' or v1:'>' then ,else v1/ fi" now >  $OUTPUT_EDBOARD
else
    echo NAO CONSEGUIR DADO DE CORPO EDITORIAL em $JOURNAL_EDBOARD_HTML_PATH/$ACRON/$FILENAME > $OUTPUT_EDBOARD
fi


echo `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5
