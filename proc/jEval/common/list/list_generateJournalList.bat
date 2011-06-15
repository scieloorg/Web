echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5 
. $1
PARM_FILE_SELECTED_TITLES=$2
PARM_FILE_NEW_TITLELIST=$3

if [ "@$PARM_FILE_SELECTED_TITLES" == "@" ]
then
    $MX cipar=$FILE_CIPAR TITLE lw=9999 "pft=if v50='C' then v100,'|',v400,'|',v68/ fi" now  > $PARM_FILE_NEW_TITLELIST
else
    $MX cipar=$FILE_CIPAR "seq=$PARM_FILE_SELECTED_TITLES" lw=9999 "pft=ref(['TITLE']l(['TITLE']'sgl=',v1),if v50='C' then v100,'|',v400,'|',v68/ fi)" now  > $PARM_FILE_NEW_TITLELIST
fi
echo lista de revista gerada em $PARM_FILE_NEW_TITLELIST