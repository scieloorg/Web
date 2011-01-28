MX=$1
FILES_LIST=$2
LANGDB=$3
TEMP_PATH=$4
cipfile=$5
CREATE_OR_APPEND=$6

TEMP1=$TEMP_PATH/t1
TEMP2=$TEMP_PATH/t2

NORMALIZED_FILENAMES=$TEMP_PATH/normalized_filenames
# invert title
# $MX cipar=$cipfile TITLE fst=@fst/title.fst fullinv=TITLE

d1=`date`
echo normalize filenames
echo `date` ./genlangdb/normalize_filenames.sh
./genlangdb/normalize_filenames.sh $MX $FILES_LIST $NORMALIZED_FILENAMES.seq
echo `date` create $NORMALIZED_FILENAMES
$MX seq=$NORMALIZED_FILENAMES.seq create=$NORMALIZED_FILENAMES now -all

echo `date` group.seq
$MX $NORMALIZED_FILENAMES lw=9999 "pft=@pft/group_by_original_filename.pft" now >  $TEMP_PATH/grouped.seq

echo `date` group
$MX cipar=$cipfile seq=$TEMP_PATH/grouped.seq  "proc=@pft/retag.prc" "proc=@pft/retag2.prc"  create=$TEMP_PATH/grouped  now -all

echo `date` invert group
$MX $TEMP_PATH/grouped fst=@fst/langs.fst fullinv=$TEMP_PATH/grouped

$MX seq=genlangdb/lowercase.seq create=genlangdb/lowercase now -all

if [ -f $TEMP1.mst ]
then
	rm -rf $TEMP1.*
fi


if [ ! -f $LANGDB.mst ]
then	
	echo `date` create1 $TEMP1 
	$MX cipar=$cipfile ARTIGO gizmo=genlangdb/lowercase,702 btell=0 "bool=hr=s$" "proc='d*',if p(v83) and p(v40) then 'a91{',date,'{','a880{',v880,'{','a40{',v40,'{','a702{',v702,'{','a700{',replace(replace(replace(replace(replace(mid(v702,instr(s(mpu,v702,mpl),'\SERIAL\')+8,size(v702)),'.html',''),'.htm',''),'.xml',''),'\markup\','\'),'\','/'),'{' fi" append=$TEMP1 now -all
else
	echo `date` create2 $TEMP1
	$MX cipar=$cipfile ARTIGO gizmo=genlangdb/lowercase,702 btell=0 "bool=hr=s$" "proc='d*',if p(v83) and l(['$LANGDB']'hr='v880)=0 and p(v40) then 'a91{',date,'{','a880{',v880,'{','a40{',v40,'{','a702{',v702,'{','a700{',replace(replace(replace(replace(replace(mid(v702,instr(s(mpu,v702,mpl),'\SERIAL\')+8,size(v702)),'.html',''),'.htm',''),'.xml',''),'\markup\','\'),'\','/'),'{' fi" append=$TEMP1 now -all
fi 

echo `date` update $TEMP1
$MX $TEMP1 "proc='a9000{',f(l(['$TEMP_PATH/grouped']'file='v700),1,0),'{'" "proc=if val(v9000)>0 then ref(['$TEMP_PATH/grouped']val(v9000),(|a601{|v601|{|),(|a602{|v602|{|)) fi" copy=$TEMP1 now -all

echo `date` append $TEMP1 to $LANGDB
$MX $TEMP1 append=$LANGDB now -all
echo `date` invert $LANGDB
$MX $LANGDB fst=@fst/langs.fst fullinv=$LANGDB

echo $d1
echo `date`
