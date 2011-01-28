MX=$1
FILES_LIST=$2
LANGDB=$3
TEMP_PATH=$4
cipfile=$5
CREATE_OR_APPEND=$6

NORMALIZED_FILENAMES=$TEMP_PATH/normalized_filenames

echo normalize filenames
./genlangdb/normalize_filenames.sh $MX $FILES_LIST $NORMALIZED_FILENAMES.seq
$MX seq=$NORMALIZED_FILENAMES.seq create=$TEMP_PATH/normalized now -all

echo invert artigo
$MX cipar=$cipfile ARTIGO fst=@fst/h.fst fullinv=ARTIGO

echo invert title
$MX cipar=$cipfile TITLE fst=@fst/title.fst fullinv=TITLE

echo group
$MX $TEMP_PATH/normalized lw=9999 lw=9999 "pft=@pft/group_by_original_filename.pft" now >  $TEMP_PATH/grouped.seq

echo create $LANGDB
echo $MX cipar=$cipfile seq=$TEMP_PATH/grouped.seq  "proc=@pft/add880.prc" "proc=@pft/retag.prc" "proc=@pft/retag2.prc" "proc='a91~',date,'~'" $CREATE_OR_APPEND=$LANGDB  now -all

$MX cipar=$cipfile seq=$TEMP_PATH/grouped.seq  "proc=@pft/add880.prc" "proc=@pft/retag.prc" "proc=@pft/retag2.prc" "proc='a91~',date,'~'" $CREATE_OR_APPEND=$LANGDB  now -all

echo invert $LANGDB
$MX $LANGDB fst=@fst/langs.fst fullinv=$LANGDB 

