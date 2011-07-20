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


if [ ! -f $LANGDB.mst ]
then	
	echo `date` create1 $TEMP1 >> $LOGFILE
	$MX cipar=$cipfile ARTIGO gizmo=sh_genlangdb/lowercase,702 btell=0 "bool=hr=s$" "proc='d9999'" "proc=@sh_genlangdb/add.prc" append=$TEMP1 now -all
else
	echo `date` create2 $TEMP1 >> $LOGFILE
    $MX $LANGDB fst=@fst/langs.fst fullinv=$LANGDB
	$MX cipar=$cipfile ARTIGO gizmo=sh_genlangdb/lowercase,702 btell=0 "bool=hr=s$" "proc='d9999a9999{$LANGDB{'" "proc=@sh_genlangdb/add.prc" append=$TEMP1 now -all
fi 

echo `date` Update $TEMP1 >> $LOGFILE
$MX $TEMP1 "proc='a9000{',f(l(['$TEMP_PATH/grouped']'file='v700),1,0),'{'" "proc='d9000',if val(v9000)>0 then ref(['$TEMP_PATH/grouped']val(v9000),(|a601{|v601|{|),(|a602{|v602|{|)) fi" copy=$TEMP1 now -all

echo `date` append $TEMP1 to $LANGDB >> $LOGFILE
$MX $TEMP1 append=$LANGDB now -all
echo `date` invert $LANGDB >> $LOGFILE
$MX $LANGDB fst=@fst/langs.fst fullinv=$LANGDB

echo `date` FIM >> $LOGFILE