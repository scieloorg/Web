# CRIA UM ARQUIVO DADO POR $OUTPUT_SEQ_v70
#  CONTENDO AS AFF DE FASCICULOS SELECIONADOS DE UM DADO TITULO

. $1

INPUT_ISSUEPID=$2
OUTPUT_SEQ_v10v70=$3

sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG $3 $2  Affiliations list
$MX cipar=$FILE_CIPAR ARTIGO btell=0 "HR=S$INPUT_ISSUEPID$" lw=9999 "pft=if p(v70) then (v880[1],v70^i*0.3,'|',v70^*,|^c|v70^c,|^s|v70^s,|^p|v70^p,'|',|^1|v70^1,|^2|v70^2,/) fi" now  >> $OUTPUT_SEQ_v10v70

