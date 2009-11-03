. $1

$MX $DBLANG btell=0 lw=9999 "pft=if p(v880) then v880,'|',v71,'|o|',v40/,if p(v601) then (v880[1],'|',v71[1],'|t|',v601^l/,) fi,if p(v602) then (if v602^l<>v40[1] then v880[1],'|',v71[1],'|t|',v602^l/ fi) fi fi" now | sort -u > temp/langs_dblangtab.txt

$MX seq=temp/langs_dblangtab.txt create=$DBLANGTAB now -all
$MX $DBLANGTAB "fst=@$PROCLANG_PATH/fst/lang.fst" fullinv=$DBLANGTAB