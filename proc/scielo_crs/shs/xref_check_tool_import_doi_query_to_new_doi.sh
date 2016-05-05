
. crossref_config.sh

DB_QUERY=$1
DOI_PREFIX=$2
COL_ID=$3
NEW_DB_DOI=$4
#scl

$cisis_dir/mx $DB_QUERY btell=0 "bool=doi={$DOI_PREFIX}$" lw=999 "pft=(if v880^c='$COL_ID' and size(v880^c)=23 then v237[1],'|',v880^*/ fi)" now > $NEW_DB_DOI.seq

$cisis_dir/mx seq=$NEW_DB_DOI.seq "proc='d*a237{',v1,'{a880{',v2,'{'," create=$NEW_DB_DOI now -all

