echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5 
. $1
SELECTED_TITLES=$2

if [ "@$SELECTED_TITLES" == "@" ]
then
    $MX cipar=$CPFILE TITLE lw=9999 "pft=if v50='C' then v100,'|',v400,'|',v68/ fi" now  > $SCILISTA
else
    $MX cipar=$CPFILE "seq=$SELECTED_TITLES" lw=9999 "pft=ref(['TITLE']l(['TITLE']'sgl=',v1),if v50='C' then v100,'|',v400,'|',v68/ fi)" now  > $SCILISTA
fi


echo lista de revista gerada em $SCILISTA