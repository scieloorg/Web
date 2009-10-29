. $1


$MX "seq=$SEQFILEALLISSUESELECTED " lw=9999 "pft='./$PATH_SHELL/getIssuesAff.bat $1 ',v1/" now > temp/je_allissuesselectedaff.bat
chmod 775 temp/je_allissuesselectedaff.bat
./temp/je_allissuesselectedaff.bat

if [ -f temp/je_1 ]
then
    rm temp/je_1
fi
cat $AFFSEQ | sort -u > temp/je_1


$MX seq=$AFFSEQ create=temp/v70 now -all
$MX temp/v70 fst=@$PATH_COMMON/fst/v70.fst fullinv=temp/v70

# gerar um gizmo incompleta (inst-city) para completa
$MX temp/v70 btell=0 "completa" lw=99999 "pft=@$PATH_COMMON/pft/aff_completa.pft" now | sort -u > temp/aff_completa.seq
$MX seq=temp/aff_completa.seq create=temp/aff_completa now -all
$MX temp/aff_completa fst=@$PATH_COMMON/fst/v70.fst fullinv=temp/aff_completa

$MX temp/v70 btell=0 "parcial" lw=99999 "proc='d970',ref(['temp/aff_completa']l(['temp/aff_completa']v2^*,v2^c,v2^s,v2^p),'a970{',v2,'{')" copy=temp/v70 now -all
