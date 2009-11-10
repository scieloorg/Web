echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5
. $1

ISSUEPID=$2
ISSN=$3
ACRON=$4
INPUT_FOR_ENDOGENIA_PROC=$5
INPUT_FOR_HISTORY_PROC=$6

FILE_RESULT_DIFF=temp/je_result_diff.txt

echo Issue $ISSUEPID
echo Authors
./$PATH_COMMON_SHELLS/WriteLog.bat $AVALLOG $ACRON $ISSN  Authors
$MX cipar=$CPFILE ARTIGO btell=0 "HR=S$ISSUEPID$" lw=9999 "pft=if p(v83) then (v31[1],'|',v32[1],'|',s(v65[1])*0.4,'|',v14^f[1],'|',v12^t[1],'|',,v10^n,| |v10^s,,'|',if p(v10^1) then ,ref(['$DB_v70']l(['$DB_v70']v880[1],v10^1*0.3),if p(v970) then v970 else v3 fi), fi,/) ,fi" now >> $INPUT_FOR_ENDOGENIA_PROC.seq

echo History
./$PATH_COMMON_SHELLS/WriteLog.bat $AVALLOG $ACRON $ISSN  History

$MX cipar=$CPFILE ARTIGO btell=0 "HR=S$ISSUEPID$" lw=9999 "pft=if size(s(v112,v114))=16 and p(v112) and p(v114) then v114,'|',v112/ fi" now > temp/je_date_range_list.txt
./$PATH_COMMON/linux/calculateDateDiff.bat $1 $FILE_RESULT_DIFF $INPUT_FOR_HISTORY_PROC.seq


echo Doctopic
if [ "@$PARAM_SELECT_BY_YEAR" == "@" ]
then
    $MX cipar=$CPFILE ARTIGO btell=0 "HR=S$ISSUEPID$" COUNT=1 lw=9999 "pft=v65*0.4" now > temp/je_YEAR
    YEAR=`cat temp/je_YEAR`
  ./$PATH_DOCTOPIC_SHELLS/doctopic_call_genLangReport.bat $FILE_CONFIG $ISSN temp/je_replang.txt $PATH_LANG_REPORTS/report_$ISSN\_year_doctopic.xls $YEAR
else
  ./$PATH_DOCTOPIC_SHELLS/doctopic_call_genLangReport.bat $FILE_CONFIG $ISSN temp/je_replang.txt $PATH_LANG_REPORTS/report_$ISSN\_year_doctopic.xls $PARAM_SELECT_BY_YEAR
fi
more temp/je_replang.txt >> $JournalFile

$MX cipar=$CPFILE ISSUE btell=0 "$ISSN$PARAM_SELECT_BY_YEAR$"  "tab=if v32<>'ahead' and v32<>'review' and a(v41) then v35 fi" now > temp/je_numbers
$MX cipar=$CPFILE ARTIGO btell=0 "HR=S$ISSUEPID$" "tab=if v32<>'ahead' and v32<>'review' and a(v41) then v880 fi" now >> temp/je_numbers

$MX cipar=$CPFILE ISSUE btell=0 "$ISSN$PARAM_SELECT_BY_YEAR$" "pft=if v32<>'ahead' and v32<>'review' and a(v41) then v35,v36*0.4,s(f(10000+val(v36*4),1,0))*1,s(f(100000+val(v122),1,0))*1 fi" now | sort -r > temp/je_issues
$MX seq=temp/je_issues count=1 "pft=v1/" now > temp/je_lastissue
f = "000100001"
l = `cat temp/je_lastissue`
$MX cipar=$CPFILE ARTIGO btell=0 "bool=hr=s$ISSN$PARAM_SELECT_BY_YEAR$f" lw=9999 "pft=if p(v14^f) then s(f(10000000+val(v14^f),1,0))*1 fi,'|',if p(v14^l) then s(f(10000000+val(v14^l),1,0))*1 fi/" now > temp/je_pages.txt
$MX cipar=$CPFILE ARTIGO btell=0 "bool=hr=s$l" lw=9999 "pft=if p(v14^f) then s(f(10000000+val(v14^f),1,0))*1 fi,'|',if p(v14^l) then s(f(10000000+val(v14^l),1,0))*1 fi/" now >> temp/je_pages.txt
$MX seq=temp/je_pages.txt create=temp/je_pages now -all
$MX temp/je_pages "pft=f(val(ref(2,v1))-val(v1),1,0)" now >> temp/je_numbers

more temp/je_numbers >> $JournalFile
