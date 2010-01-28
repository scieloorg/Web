# CRIA UM ARQUIVO DADO POR $SEQ_DB_v70
#  CONTENDO AS AFF DE FASCICULOS SELECIONADOS DE UM DADO TITULO

. $1

LOCAL_ISSUEPID=$2

# optional acron
LOCAL_ACRON=$4
LOCAL_SEQ_DB_v70=$3

./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG $3 $2  Affiliations list
$MX cipar=$FILE_CIPAR ARTIGO btell=0 "HR=S$LOCAL_ISSUEPID$" lw=9999 "pft=if p(v70) then (v880[1],v70^i*0.3,'|',v70^*,|^c|v70^c,|^s|v70^s,|^p|v70^p,'|',|^1|v70^1,|^2|v70^2,/) fi" now >> $LOCAL_SEQ_DB_v70

