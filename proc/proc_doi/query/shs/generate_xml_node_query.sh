CONFIG=$1
PID=$2
XML=$3
. shs/readconfig.sh

if [ "@" == "@$XML" ]
then
    $MX cipar=$CIPFILE ARTIGO btell=0 "hr=$PID or r=$PID" gizmo=shs/ent gizmo=shs/ent2 lw=9999 "pft=@pft/xml.pft" now
else
    $MX cipar=$CIPFILE ARTIGO btell=0 "hr=$PID or r=$PID" gizmo=shs/ent gizmo=shs/ent2 lw=9999 "pft=@pft/xml.pft" now >> $XML
fi


