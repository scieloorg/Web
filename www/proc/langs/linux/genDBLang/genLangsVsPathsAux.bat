. $1
lang=$2

echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG

$MX seq=$PROCLANG_PATH/tables/paths.seq "pft=v1,'|',v2,'|',v3,'|$lang'/" now  >> $PROCLANG_PATH/tables/lang_paths.seq

echo      [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG
