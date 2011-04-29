# SELECIONA OS FASCICULOS (DE UM DADO TITULO) DE ONDE SERAO RETIRADOS OS DADOS
# RETORNA UMA LISTA COM OS FASCICULOS
# Param 1 arquivo com valores de variaveis
# Param 2 LOCAL_ISSN
# Param 3 LOCAL_ACRON
# Param 4 LOCAL_FILE_SELECTED_ISSUES

echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5

. $1
LOCAL_ISSN=$2
LOCAL_ACRON=$3
LOCAL_FILE_SELECTED_ISSUES=$4
LOCAL_FILE_ALL_SELECTED_ISSUES=$5

./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG $LOCAL_ACRON Select issues

if [ "@$PARAM_SELECT_BY_YEAR" == "@" ]
then
    $MX cipar=$FILE_CIPAR ISSUE btell=0 "seq=$LOCAL_ISSN$" lw=9999  "pft=if a(v131) and a(v132) and v32<>'ahead' and v32<>'review' and a(v41) then v35,v36*0.4,s(f(10000+val(v36*4),4,0))*1/ fi" now | sort -u -r > $LOCAL_FILE_SELECTED_ISSUES.seq
else
    $MX cipar=$FILE_CIPAR ISSUE btell=0 "seq=$LOCAL_ISSN$" lw=9999  "pft=if v36*0.4='$PARAM_SELECT_BY_YEAR' then if a(v131) and a(v132) and v32<>'ahead' and v32<>'review' and a(v41) then v35,v36*0.4,s(f(10000+val(v36*4),4,0))*1/ fi fi" now | sort -u -r > $LOCAL_FILE_SELECTED_ISSUES.seq
fi
echo >> $LOCAL_FILE_SELECTED_ISSUES.seq
if [ "@$PARAM_SELECT_BY_RECENT" != "@" ]
then
     $MX "seq=$LOCAL_FILE_SELECTED_ISSUES.seq " create=$LOCAL_FILE_SELECTED_ISSUES now -all
     $MX $LOCAL_FILE_SELECTED_ISSUES count=$PARAM_SELECT_BY_RECENT lw=9999 "pft=v1/" now > $LOCAL_FILE_SELECTED_ISSUES.seq
fi
cat $LOCAL_FILE_SELECTED_ISSUES.seq >> $LOCAL_FILE_ALL_SELECTED_ISSUES

echo `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5