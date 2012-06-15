. config.sh

DB_SRC=$1
MFN=$2
XML_FILE_LIST=$3

./reglog.sh $0 " Generate XML $DB_SRC $MFN"
#$MX $DB_SRC from=$MFN count=1 gizmo=../gizmo/ent gizmo=../gizmo/ent2 lw=9999 "pft=@../pft/xml.pft" append=$XML_FILE_LIST now -all
$MX $DB_SRC from=$MFN count=1 gizmo=../gizmo/ent gizmo=../gizmo/ent2 lw=9999 "pft=@../pft/xml.pft" now > $XML_FILE_LIST.$MFN.xml
echo $XML_FILE_LIST.$MFN.xml >> $XML_FILE_LIST.seq
