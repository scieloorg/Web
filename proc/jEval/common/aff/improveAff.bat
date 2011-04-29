. $1

echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5

# Cria um arquivo sequencial com
# v1 = v880 + v70^i (id da aff)
# v2 = v70^*,|^c|v70^c,|^s|v70^s,|^p|v70^p
# v3 = |^1|v70^1,|^2|v70^2

# $FILE_CONFIG $FILE_SELECTED_ISSUES.txt $SEQ_DB_v70 $DB_v70 $DB_v70_completa

LOCAL_FILE_SELECTED_ISSUES=$2
LOCAL_SEQ_DB_v70=$3
LOCAL_DB_v70=$4
LOCAL_DB_v70_completa=$5

if [ -f $LOCAL_SEQ_DB_v70 ]
then
    rm $LOCAL_SEQ_DB_v70
fi
$MX "seq=$LOCAL_FILE_SELECTED_ISSUES " lw=9999 "pft=if size(v1)>0 then './$PATH_AFF_MODULE/getIssuesAff.bat $1 ',v1,' $LOCAL_SEQ_DB_v70'/ fi" now > temp/je_allissuesselectedaff.bat
chmod 775 temp/je_allissuesselectedaff.bat
./temp/je_allissuesselectedaff.bat

echo Create DB_v70 from seq
# LOCAL_SEQ_DB_v70 contem todas as aff
$MX "seq=$LOCAL_SEQ_DB_v70" create=$LOCAL_DB_v70 now -all
$MX $LOCAL_DB_v70 fst=@$PATH_AFF_MODULE/v70.fst fullinv=$LOCAL_DB_v70

echo Atualizar a base de aff completas
########################
# LOCAL_SEQ_DB_v70 contem todas as aff
# Le todas as aff e gera uma lista somente com as completas
# Faz append desta lista na lista completa talvez já pre-existente
########################
if [ ! -f "$LOCAL_DB_v70_completa.mst" ]
then
    $MX null count=1 "proc='a999{',date,'{'" create=$LOCAL_DB_v70_completa now -all
    $MX $LOCAL_DB_v70_completa fst=@$PATH_AFF_MODULE/v70_completa.fst fullinv=$LOCAL_DB_v70_completa
fi
echo > $LOCAL_DB_v70_completa.seq
$MX $LOCAL_DB_v70 btell=0 "completa" lw=99999 "pft=if l(['$LOCAL_DB_v70_completa'],v2^*,v2^c,v2^s,v2^p)=0 then v2/ fi" now | sort -u > $LOCAL_DB_v70_completa.seq
$MX seq=$LOCAL_DB_v70_completa.seq append=$LOCAL_DB_v70_completa now -all
$MX $LOCAL_DB_v70_completa fst=@$PATH_AFF_MODULE/v70_completa.fst fullinv=$LOCAL_DB_v70_completa
$MX $LOCAL_DB_v70 btell=0 "parcial" lw=99999 "proc=ref(['$LOCAL_DB_v70_completa']l(['$LOCAL_DB_v70_completa']v2^*,v2^c,v2^s,v2^p),'d2','a2{',v1,'{a444{completed{')" copy=$LOCAL_DB_v70 now -all
$MX $LOCAL_DB_v70 fst=@$PATH_AFF_MODULE/v70.fst fullinv=$LOCAL_DB_v70


echo `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5