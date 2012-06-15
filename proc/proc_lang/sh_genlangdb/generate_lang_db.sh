MX=$1
FILES_LIST=$2
LANGDB=$3
TEMP_PATH=$4
cipfile=$5
LOGFILE=$6

TEMP1=$TEMP_PATH/t1
TEMP2=$TEMP_PATH/t2
TEMP3=$TEMP_PATH/t3

NORMALIZED_FILENAMES=$TEMP_PATH/normalized_filenames
# invert title
# $MX cipar=$cipfile TITLE fst=@fst/title.fst fullinv=TITLE

echo `date` generate_lang_db.sh $1 $2 $3 $4 $5 $6 $7> $LOGFILE

d1=`date`
echo `date` Normalize filenames >> $LOGFILE

echo `date` Select valid paths >> $LOGFILE
$MX "seq=$FILES_LIST/" lw=9999 "pft=@sh_genlangdb/normalize.pft" now | sort -u > $NORMALIZED_FILENAMES.seq
$MX seq=$NORMALIZED_FILENAMES.seq create=$NORMALIZED_FILENAMES now -all

echo `date` Create $TEMP_PATH/grouped.seq >> $LOGFILE
$MX $NORMALIZED_FILENAMES lw=9999 "pft=@pft/group_by_original_filename.pft" now >  $TEMP_PATH/grouped.seq

echo `date` Create $TEMP_PATH/grouped >> $LOGFILE
$MX cipar=$cipfile seq=$TEMP_PATH/grouped.seq  "proc=@pft/retag.prc" "proc=@pft/retag2.prc"  create=$TEMP_PATH/grouped  now -all

echo `date` Invert $TEMP_PATH/grouped >> $LOGFILE
$MX $TEMP_PATH/grouped fst=@fst/langs.fst fullinv=$TEMP_PATH/grouped

echo `date` Create sh_genlangdb/lowercase >> $LOGFILE
$MX seq=sh_genlangdb/lowercase.seq create=sh_genlangdb/lowercase now -all

if [ -f $TEMP1.mst ]
then
	rm -rf $TEMP1.*
fi



echo `date` create1 $TEMP1 >> $LOGFILE
$MX null count=0 create=$LANGDB now -all
$MX cipar=$cipfile ARTIGO gizmo=sh_genlangdb/lowercase,702 btell=0 "bool=hr=s$" "proc='d9999a9999{$TEMP_PATH/grouped{'" "proc=@sh_genlangdb/add.prc" append=$LANGDB now -all

$MX $LANGDB fst=@fst/langs.fst fullinv=$LANGDB

echo `date` FIM >> $LOGFILE