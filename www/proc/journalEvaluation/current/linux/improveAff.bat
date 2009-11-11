. $1

echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5

# Cria um arquivo sequencial com
# v1 = v880 + v70^i (id da aff)
# v2 = v70^*,|^c|v70^c,|^s|v70^s,|^p|v70^p
# v3 = |^1|v70^1,|^2|v70^2
$MX "seq=$FILE_SELECTED_ISSUES.txt " lw=9999 "pft=if size(v1)>0 then './$PATH_CURRENT_SHELLS/getIssuesAff.bat $1 ',v1/ fi" now > temp/je_allissuesselectedaff.bat
chmod 775 temp/je_allissuesselectedaff.bat
./temp/je_allissuesselectedaff.bat

echo Create DB_v70 from seq
$MX "seq=$SEQ_DB_v70" create=$DB_v70 now -all
$MX $DB_v70 fst=@$PATH_COMMON/fst/v70.fst fullinv=$DB_v70

echo Atualizar a base de aff completas
# cat $DB_v70_completa.seq > temp/aff_completas.seq
# $MX $DB_v70 btell=0 "completa" lw=99999 "pft=v2/" now | sort -u >> temp/aff_completas.seq
# cat temp/aff_completas.seq | sort -u > $DB_v70_completa.seq
# $MX seq=$DB_v70_completa.seq create=$DB_v70_completa now -all

$MX $DB_v70 btell=0 "completa" lw=99999 "pft=if l(['$DB_v70_completa'],v2^*,v2^c,v2^s,v2^p)=0 then v2/ fi" now | sort -u > temp/aff_completas.seq
$MX seq=$DB_v70_completa.seq append=$DB_v70_completa now -all
$MX $DB_v70_completa fst=@$PATH_COMMON/fst/v70_completa.fst fullinv=$DB_v70_completa

$MX $DB_v70 btell=0 "parcial" lw=99999 "proc=ref(['$DB_v70_completa']l(['$DB_v70_completa']v2^*,v2^c,v2^s,v2^p),'d2','a2{',v1,'{')" copy=$DB_v70 now -all

echo `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5