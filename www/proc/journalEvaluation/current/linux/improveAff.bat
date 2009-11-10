. $1

echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5

$MX "seq=$FILE_SELECTED_ISSUES.txt " lw=9999 "pft=if size(v1)>0 then './$PATH_CURRENT_SHELLS/getIssuesAff.bat $1 ',v1/ fi" now > temp/je_allissuesselectedaff.bat
chmod 775 temp/je_allissuesselectedaff.bat
./temp/je_allissuesselectedaff.bat

cp $SEQ_DB_v70 temp/je_1
cat temp/je_1 | sort -u > $SEQ_DB_v70

echo Create DB_v70 from seq
$MX "seq=$SEQ_DB_v70" create=$DB_v70 now -all
$MX $DB_v70 fst=@$PATH_COMMON/fst/v70.fst fullinv=$DB_v70

echo Gerar um gizmo incompleta (inst-city) para completa
$MX $DB_v70 btell=0 "completa" lw=99999 "pft=@$PATH_COMMON/pft/aff_completa.pft" now | sort -u > $DB_v70_completa.seq
$MX seq=$DB_v70_completa.seq create=$DB_v70_completa now -all
$MX $DB_v70_completa fst=@$PATH_COMMON/fst/v70.fst fullinv=$DB_v70_completa

$MX $DB_v70 btell=0 "parcial" lw=99999 "proc='d970',ref(['$DB_v70_completa']l(['$DB_v70_completa']v2^*,v2^c,v2^s,v2^p),'a970{',v2,'{')" copy=$DB_v70 now -all

echo `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5