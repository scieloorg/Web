MX=$1
FILES_LIST=$2
LANGDB=$3
TEMP_PATH=$4
cipfile=$5
CREATE_OR_APPEND=$6

NORMALIZED_FILENAMES=$TEMP_PATH/normalized_filenames
# invert title
$MX cipar=$cipfile TITLE fst=@fst/title.fst fullinv=TITLE

# normalize filenames
./genlangdb/normalize_filenames.sh $MX $FILES_LIST $NORMALIZED_FILENAMES.seq
$MX seq=$NORMALIZED_FILENAMES.seq create=$TEMP_PATH/normalized now -all
$MX $TEMP_PATH/normalized lw=9999 lw=9999 "pft=@pft/group_by_original_filename.pft" now >  $TEMP_PATH/grouped.seq
$MX cipar=$cipfile seq=$TEMP_PATH/grouped.seq  "proc=@pft/retag.prc" "proc=@pft/retag2.prc"  create=$TEMP_PATH/grouped  now -all


# generate db lang from artigo db
if [ "@$CREATE_OR_APPEND" == "@create" ]
then
	$MX cipar=$cipfile ARTIGO btell=0 "bool=hr=s$" create=$LANGDB now -all
else
	$MX cipar=$cipfile ARTIGO btell=0 "bool=hr=s$" "proc='d*',if l(['$LANGDB']'hr='v880)=0 then 'a880~'v880'~','a91~',date,'~','a40~'v40'~','a702~'v702'~' fi" append=$LANGDB now -all
fi
$MX $LANGDB fst=@fst/langs.fst fullinv=$LANGDB



$MX $TEMP_PATH/grouped fst=@fst/langs.fst fullinv=$TEMP_PATH/grouped 

