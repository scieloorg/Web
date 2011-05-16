. $1

echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5

# DADOS:
# PARAM 2 INPUT_FILE_ALL_SELECTED_ISSUES: issues selecionados
# PARAM 3 OUTPUT_DB_v10v70      : saida base de v10v70 dos issues (completada)
# PARAM 4 INPUT_DB_v70_completa : entrada base v70 completas (permanente)

# base v10v70
# v1 = v880 + v70^i (id da aff)
# v2 = v70^*,|^c|v70^c,|^s|v70^s,|^p|v70^p
# v3 = |^1|v70^1,|^2|v70^2
# v444 = completed

INPUT_FILE_ALL_SELECTED_ISSUES=$2
OUTPUT_DB_v10v70=$3
INPUT_DB_v70_completa=$4

AFF_TEMP=$APP_TEMP_PATH/aff
LOCAL_SEQ_v10v70=$AFF_TEMP/v10v70.seq
LOCAL_DB_v10v70=$AFF_TEMP/v10v70
LOCAL_SEQ_v70_completa=$AFF_TEMP/v70_completa

if [ ! -d $AFF_TEMP ]
then
    mkdir -p $AFF_TEMP
fi

if [ -f $LOCAL_SEQ_v10v70 ]
then
    rm $LOCAL_SEQ_v10v70
fi

####
#   GERA V10 + V70
# Pela lista de issues selecionados, gera um seq com v10 + v70
$MX "seq=$INPUT_FILE_ALL_SELECTED_ISSUES " lw=9999 "pft=if size(v1)>0 then 'sh ./$PATH_AFF_MODULE/getIssuesAff.bat $1 ',v1,' $LOCAL_SEQ_v10v70'/ fi" now > $AFF_TEMP/getIssuesAff.bat
sh $AFF_TEMP/getIssuesAff.bat
$MX "seq=$LOCAL_SEQ_v10v70" create=$OUTPUT_DB_v10v70 now -all
$MX $OUTPUT_DB_v10v70 fst=@$PATH_AFF_MODULE/v10v70.fst fullinv=$OUTPUT_DB_v10v70

####
#   ATUALIZA V70 COMPLETA
if [ ! -f $INPUT_DB_v70_completa.mst ]
then
    $MX null count=1 "proc='a999{',date,'{'" create=$INPUT_DB_v70_completa now -all
    $MX $INPUT_DB_v70_completa fst=@$PATH_AFF_MODULE/v70_completa.fst fullinv=$INPUT_DB_v70_completa
fi
$MX $OUTPUT_DB_v10v70 btell=0 "bool=completa" lw=9999 "pft=if l(['$INPUT_DB_v70_completa']v2)=0 then v2/ fi" now | sort -u > $LOCAL_SEQ_v70_completa
$MX seq=$LOCAL_SEQ_v70_completa append=$INPUT_DB_v70_completa now -all
$MX $INPUT_DB_v70_completa fst=@$PATH_AFF_MODULE/v70_completa.fst fullinv=$INPUT_DB_v70_completa

####
#   ATUALIZA V10 + V70, COM AFF COMPLETAS

$MX $OUTPUT_DB_v10v70 btell=0 "parcial" lw=99999 "proc=ref(['$INPUT_DB_v70_completa']l(['$INPUT_DB_v70_completa']v2),'d2','a2{',v1,'{a444{completed{')" copy=$OUTPUT_DB_v10v70 now -all
$MX $OUTPUT_DB_v10v70 fst=@$PATH_AFF_MODULE/v10v70.fst fullinv=$OUTPUT_DB_v10v70


echo `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5