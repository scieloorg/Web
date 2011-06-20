CONFIG=$1
PID=$2
XML=$3
COL=$4
. shs/readconfig.sh

if [ ! "@" == "@$XML" ]
then
    if [ ! "@" == "@$COL" ]
    then
        $MX cipar=$CIPFILE ARTIGO btell=0 "hr=$PID or r=$PID" gizmo=shs/ent gizmo=shs/ent2 lw=9999 "proc='a691{$COL{'" "pft=@pft/xml.pft" now >> $XML
    fi
fi


