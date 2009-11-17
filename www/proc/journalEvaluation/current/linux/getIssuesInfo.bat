echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5
. $1

ISSUEPID=$2
ISSN=$3
ACRON=$4
INPUT_FOR_ENDOGENIA_PROC=$5
FILE_DATES=$6
FILE_NUMBERS=$7

FILE_TEMP_NUMBERS=temp/je_numbers


echo Issue $ISSUEPID autores

./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG $ACRON $ISSN  Authors
$MX cipar=$FILE_CIPAR ARTIGO btell=0 "HR=S$ISSUEPID$" lw=9999 "pft=if p(v83) then (v31[1],'|',v32[1],'|',s(v65[1])*0.4,'|',v14^f[1],'|',v12^t[1],'|',,v10^n,| |v10^s,,'|',if p(v10^1) then ,ref(['$DB_v70']l(['$DB_v70']v880[1],v10^1*0.3),v2^*,'|',v3^1,|, |v3^2,'|',v2^c,'|',v2^s,'|',v2^p), fi,/) ,fi" now >> $INPUT_FOR_ENDOGENIA_PROC.seq

echo Issue $ISSUEPID  History
./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG $ACRON $ISSN  History

$MX cipar=$FILE_CIPAR ARTIGO btell=0 "HR=S$ISSUEPID$" lw=9999 "pft=if size(s(v112,v114))=16 and p(v112) and p(v114) then v114,'|',v112/ fi" now >> $FILE_DATES

if [ "@$PARAM_SELECT_BY_YEAR" == "@" ]
then
    $MX cipar=$FILE_CIPAR ARTIGO btell=0 "HR=S$ISSUEPID$" count=1 lw=9999 "pft=v65*0.4" now > temp/je_YEAR
fi

echo Issue $ISSUEPID Numbers
$MX cipar=$FILE_CIPAR ISSUE btell=0 "$ISSUEPID$"  "tab=if v32<>'ahead' and v32<>'review' and a(v41) then v35 fi" now > $FILE_TEMP_NUMBERS.seq
$MX cipar=$FILE_CIPAR ARTIGO btell=0 "HR=S$ISSUEPID$" "tab=if v32<>'ahead' and v32<>'review' and a(v41) then 'artigos' fi" now >> $FILE_TEMP_NUMBERS.seq

$MX cipar=$FILE_CIPAR ARTIGO btell=0 "bool=hr=s$ISSUEPID$" lw=9999 "pft=if p(v14^f) then s(f(10000000+val(v14^f),1,0))*1 fi,'|',if p(v14^l) then s(f(10000000+val(v14^l),1,0))*1 fi/" now  >>  $FILE_TEMP_NUMBERS.seq
 echo >>  $FILE_TEMP_NUMBERS.seq

if [ -f "$FILE_NUMBERS.mst" ]
then

    $MX seq=$FILE_TEMP_NUMBERS.seq create=$FILE_TEMP_NUMBERS now -all
echo numbers_temp
    $MX $FILE_TEMP_NUMBERS count=2 now
echo numbers
    $MX $FILE_NUMBERS count=2 now

    $MX $FILE_NUMBERS from=1 count=2 "proc='d2a2{',f(val(v2)+val(ref(['$FILE_TEMP_NUMBERS']mfn,v2)),1,0),'{'" copy=$FILE_NUMBERS now -all
    $MX $FILE_TEMP_NUMBERS from=3 append=$FILE_NUMBERS now -all
echo numbers
    $MX $FILE_NUMBERS count=2 now
else
    more $FILE_TEMP_NUMBERS.seq
    $MX seq=$FILE_TEMP_NUMBERS.seq create=$FILE_NUMBERS now -all
fi
