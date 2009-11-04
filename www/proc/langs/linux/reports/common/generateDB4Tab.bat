. $1

$MX $DBLANG btell=0 lw=9999 "pft=@$BATCHES_PATH/reports/common/gera_dblangtab.pft" now | sort -u > temp/langs_dblangtab.txt

$MX seq=temp/langs_dblangtab.txt create=$DBLANGTAB now -all
$MX $DBLANGTAB "fst=@$PROCLANG_PATH/fst/lang_tab.fst" fullinv=$DBLANGTAB