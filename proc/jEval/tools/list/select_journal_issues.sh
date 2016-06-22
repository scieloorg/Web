# SELECIONA OS FASCICULOS (DE UM DADO TITULO) DE ONDE SERAO RETIRADOS OS DADOS
# ADICONA OS FASCICULOS DO TITULO EM UMA LISTA QUE CONTEM TODOS OS FASC SELECIONADOS
# RETORNA UMA LISTA COM OS FASCICULOS DO TITULO


. $1

sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Executing $0 $1 $2 $3 $4 $5"

PARM_ISSN=$2
PARM_ACRON=$3
JOURNAL_ISSUES_SELECTED=$4
ALL_ISSUES_SELECTED=$5

TEMP_SELECTED=$JOURNAL_ISSUES_SELECTED.TXT

if [ ! -d $PATH_OUTPUT/$PARM_ACRON ]
then
    mkdir -p $PATH_OUTPUT/$PARM_ACRON
fi



if [ "@$PARAM_SELECT_BY_YEAR" == "@" ]
then
    sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG $PARM_ACRON Select issues BY MOST RECENT
    $MX cipar=$FILE_CIPAR ISSUE btell=0 "seq=$PARM_ISSN$" lw=9999  "pft=if a(v131) and a(v132) and v32<>'ahead' and v32<>'review' and instr(v32,'spe')=0 and a(v41) then v35,v36*0.4,s(f(10000+val(v36*4.3),4,0))*1/ fi" now | sort -u -r > $TEMP_SELECTED
    echo >> $TEMP_SELECTED
    ls -l $TEMP_SELECTED
    $MX "seq=$TEMP_SELECTED" count=$PARAM_SELECT_BY_RECENT create=$JOURNAL_ISSUES_SELECTED now -all

else
    sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG $PARM_ACRON Select issues BY YEAR
    $MX cipar=$FILE_CIPAR ISSUE btell=0 "seq=$PARM_ISSN$" lw=9999  "pft=if v36*0.4='$PARAM_SELECT_BY_YEAR' then if a(v131) and a(v132) and v32<>'ahead' and v32<>'review' and a(v41) then v35,v36*0.4,s(f(10000+val(v36*4.3),4,0))*1/ fi fi" now | sort -u -r > $TEMP_SELECTED
    $MX "seq=$TEMP_SELECTED" create=$JOURNAL_ISSUES_SELECTED now -all
fi

$MX $JOURNAL_ISSUES_SELECTED lw=999 "pft=v1/" now >> $ALL_ISSUES_SELECTED

sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Executed $0 $1 $2 $3 $4 $5"
