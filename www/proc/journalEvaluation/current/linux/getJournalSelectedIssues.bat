# SELECIONA OS FASCICULOS (DE UM DADO TITULO) DE ONDE SERAO RETIRADOS OS DADOS
# RETORNA UMA LISTA COM OS FASCICULOS
# Param 1 arquivo com valores de variaveis
# Param 2 ISSN
# Param 3 ACRON
# Param 4 SEQFILE

echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5

. $1
ISSN=$2
ACRON=$3
SEQFILE=$4

./$PATH_COMMON_SHELLS/WriteLog.bat $AVALLOG $ACRON Select issues

if [ "@$PARAM_SELECT_BY_YEAR" == "@" ]
then
    $MX cipar=$CPFILE ISSUE btell=0 "seq=$ISSN$" lw=9999  "pft=if a(v131) and a(v132) and v32<>'ahead' and v32<>'review' and a(v41) then v35,v36*0.4,s(f(10000+val(v36*4),4,0))*1/ fi" now | sort -u -r > $SEQFILE.seq
else
    $MX cipar=$CPFILE ISSUE btell=0 "seq=$ISSN$" lw=9999  "pft=if v36*0.4='$PARAM_SELECT_BY_YEAR' then if a(v131) and a(v132) and v32<>'ahead' and v32<>'review' and a(v41) then v35,v36*0.4,s(f(10000+val(v36*4),4,0))*1/ fi fi" now | sort -u -r > $SEQFILE.seq
fi
echo >> $SEQFILE.seq
if [ "@$PARAM_SELECT_BY_RECENT" != "@" ]
then
     $MX "seq=$SEQFILE.seq " create=$SEQFILE now -all
     $MX $SEQFILE count=$PARAM_SELECT_BY_RECENT lw=9999 "pft=v1/" now > $SEQFILE.seq
fi

echo `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5