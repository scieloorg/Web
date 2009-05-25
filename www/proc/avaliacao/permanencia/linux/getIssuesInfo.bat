# Param 1 pid issue
# Param 2 acron
# Param 3 pid issue
# Param 4 acron

MX=$3
CPFILE=$4
#

INPUT_FOR_ENDOGENIA_PROC=$5
INPUT_FOR_HISTORY_PROC=$6
AVALLOG=$7


echo Issue $1


echo c
./avaliacao/permanencia/linux/WriteLog.bat $AVALLOG $2 $1  Authors
$MX cipar=$CPFILE ARTIGO btell=0 "HR=S$1$" lw=9999 "pft=if p(v83) then (v31[1],'|',v32[1],'|',s(v65[1])*0.4,'|',v14^f[1],'|',v12^t[1],'|',,v10^n,| |v10^s,,'|',if p(v10^1) then ,ref(['temp/v70']l(['temp/v70']v880[1],v10^1*0.3),if p(v970) then v970 else v3 fi), fi,/) ,fi" now >> $INPUT_FOR_ENDOGENIA_PROC.seq

echo d
./avaliacao/permanencia/linux/WriteLog.bat $AVALLOG $2 $1  History
$MX cipar=$CPFILE ARTIGO btell=0 "HR=S$1$" lw=9999 "pft=if size(s(v112,v114))=16 and p(v112) and p(v114) then v112*0.4,'-',v112*4.2,'-',v112*6.2,'|',v114*0.4,'-',v114*4.2,'-',v114*6.2,' 1'/ fi" now >> $INPUT_FOR_HISTORY_PROC.seq


