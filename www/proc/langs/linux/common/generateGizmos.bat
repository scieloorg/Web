. $1
$BATCHES_PATH/common/seq2mst.bat $1 $PROCLANG_PATH/tables/langs.seq $GZM_LANG

$MX $TITLE lw=9999 "pft=v400,'|',v100/" now > temp/langs_issn.seq
$BATCHES_PATH/common/seq2mst.bat $1 temp/langs_issn.seq $GZM_ISSN

$BATCHES_PATH/common/seq2mst.bat $1 $PROCLANG_PATH/tables/ot.seq $GZM_OT
$BATCHES_PATH/common/seq2mst.bat $1 $PROCLANG_PATH/tables/doctopic.seq $GZM_DOCTOPIC

# $BATCHES_PATH/common/seq2mst.bat $1 $PROCLANG_PATH/tables/pipe2ptvirg.seq $GZM_TAB SPACE
$BATCHES_PATH/common/seq2mst.bat $1 $PROCLANG_PATH/tables/pipe2tab.seq $GZM_TAB SPACE
