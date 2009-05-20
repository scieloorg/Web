# Param 1 pid issue
# Param 2 acron
# Param 3 pid issue
# Param 4 acron

export MX=$3
export CPFILE=$4
#

export XML_EXCEL=$5

export INPUT_FOR_ENDOGENIA_PROC=$6
export INPUT_FOR_HISTORY_PROC=$7



$MX cipar=$CPFILE ARTIGO btell=0 "HR=S$1$" lw=9999 "proc='d9700','a9700{',(v70^i,'[',v70^*,'||',v70^c,'|',v70^s,'|',v70^p,']',v70^i),'{'" "pft=(v880[1],'|',v31[1],'|',v32[1],'|',s(v65[1])*0.4,'|',v14^f[1],'|',v12^t[1],'|',,v10^n,| |v10^s,,'|',mid(v9700[1],instr(v9700[1],s(v10^1,'['))+4,instr(v9700[1],s(']',v10^1))-instr(v9700[1],s(v10^1,'['))-4)/)" now > $INPUT_FOR_ENDOGENIA_PROC.seq

$MX seq=$INPUT_FOR_ENDOGENIA_PROC.seq append=$INPUT_FOR_ENDOGENIA_PROC now -all

$MX null count=1 lw=9999 "pft=@avaliacao/pft/data_extracted_from_db.xls.04_a.pft" now >> $XML_EXCEL
$MX $INPUT_FOR_ENDOGENIA_PROC lw=9999 "pft=@avaliacao/pft/data_extracted_from_db.xls.04_b.pft" now >> $XML_EXCEL
$MX null count=1 lw=9999 "pft=@avaliacao/pft/data_extracted_from_db.xls.04_c.pft" now >> $XML_EXCEL



$MX cipar=$CPFILE ARTIGO btell=0 "HR=S$1$" lw=9999 "pft=v880,'|',v112,'|',v114/" now > $INPUT_FOR_HISTORY_PROC.seq
$MX seq=$INPUT_FOR_HISTORY_PROC.seq append=$INPUT_FOR_HISTORY_PROC now -all

$MX null count=1 lw=9999 "pft=@avaliacao/pft/data_extracted_from_db.xls.05_a.pft" now >> $XML_EXCEL
$MX $INPUT_FOR_HISTORY_PROC lw=9999 "pft=@avaliacao/pft/data_extracted_from_db.xls.05_b.pft" now >> $XML_EXCEL
$MX null count=1 lw=9999 "pft=@avaliacao/pft/data_extracted_from_db.xls.05_c.pft" now >> $XML_EXCEL

