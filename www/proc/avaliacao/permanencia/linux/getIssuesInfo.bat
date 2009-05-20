# Param 1 pid issue
# Param 2 acron
# Param 3 pid issue
# Param 4 acron

export MX=$3
export CPFILE=$4
#

export INPUT_FOR_ENDOGENIA_PROC=$5
export INPUT_FOR_HISTORY_PROC=$6
export AFFLIST=$7
export AVALLOG=$8

./avaliacao/permanencia/linux/WriteLog.bat $AVALLOG $2 $1  Afiliations list
$MX cipar=$CPFILE ARTIGO btell=0 "HR=S$1$" lw=9999 "pft=if p(v83) then (v70^*,',,',v70^c,',',v70^s,',',v70^p,'|',v70^*,'||',v70^c,'|',v70^s,'|',v70^p/) fi" now >> $AFFLIST

more $AFFLIST | sort -u > temp/avaliacao_aff.txt

cp temp/avaliacao_aff.txt $AFFLIST

./avaliacao/permanencia/linux/WriteLog.bat $AVALLOG $2 $1  Afiliations check
$MX cipar=$CPFILE ARTIGO btell=0 "HR=S$1$" lw=9999 "proc='d9700','a9700{',(v70^i,'[',v70^*,'||',v70^c,'|',v70^s,'|',v70^p,']',v70^i),'{'" "pft=if p(v83) then (v10/),(v70/),(v31[1],'|',v32[1],'|',s(v65[1])*0.4,'|',v14^f[1],'|',v12^t[1],'|',,v10^n,| |v10^s,,'|',if p(v10^1) then mid(v9700[1],instr(v9700[1],s(v10^1*0.3,'['))+4,instr(v9700[1],s(']',v10^1*0.3))-instr(v9700[1],s(v10^1*0.3,'['))-4),  else '|||' fi,#  ) fi" now >> $INPUT_FOR_ENDOGENIA_PROC.teste.txt


./avaliacao/permanencia/linux/WriteLog.bat $AVALLOG $2 $1  Authors
$MX cipar=$CPFILE ARTIGO btell=0 "HR=S$1$" lw=9999 "proc='d9700','a9700{',(v70^i,'[',v70^*,',,',v70^c,',',v70^s,',',v70^p,']',v70^i),'{'" "pft=if p(v83) then (v31[1],'|',v32[1],'|',s(v65[1])*0.4,'|',v14^f[1],'|',v12^t[1],'|',,v10^n,| |v10^s,,'|',if p(v10^1) then mid(v9700[1],instr(v9700[1],s(v10^1*0.3,'['))+4,instr(v9700[1],s(']',v10^1*0.3))-instr(v9700[1],s(v10^1*0.3,'['))-4),  else ',,,,' fi,#  ) fi" now >> $INPUT_FOR_ENDOGENIA_PROC.seq


./avaliacao/permanencia/linux/WriteLog.bat $AVALLOG $2 $1  History
$MX cipar=$CPFILE ARTIGO btell=0 "HR=S$1$" lw=9999 "pft=if size(s(v112,v114))=16 and p(v112) and p(v114) then v112*0.4,'-',v112*4.2,'-',v112*6.2,'|',v114*0.4,'-',v114*4.2,'-',v114*6.2,' 1'/ fi" now >> $INPUT_FOR_HISTORY_PROC.seq
$MX "seq=$INPUT_FOR_HISTORY_PROC.seq¨" gizmo=avaliacao/gizmo/tab lw=9999  "pft=v1/"  now >> $INPUT_FOR_HISTORY_PROC.txt

