. config.sh 

echo `date`

if [ ! -d  $TEMP_PATH ]
then 
	mkdir -p $TEMP_PATH
	
fi
chmod -R 777 $TEMP_PATH

echo ARTIGO.mst=$ARTIGODB.mst > $CIPFILE
echo ARTIGO.xrf=$ARTIGODB.xrf >>$CIPFILE 
echo ARTIGO.n02=$ARTIGOIF.n02 >>$CIPFILE
echo ARTIGO.ly2=$ARTIGOIF.ly2 >>$CIPFILE
echo ARTIGO.cnt=$ARTIGOIF.cnt >>$CIPFILE
echo ARTIGO.ly1=$ARTIGOIF.ly1 >>$CIPFILE
echo ARTIGO.n01=$ARTIGOIF.n01 >>$CIPFILE
echo ARTIGO.iyp=$ARTIGOIF.iyp >>$CIPFILE
echo TITLE.mst=$TITLEDB.mst >>$CIPFILE
echo TITLE.xrf=$TITLEDB.xrf >>$CIPFILE 
echo TITLE.n02=$TITLEIF.n02 >>$CIPFILE
echo TITLE.ly2=$TITLEIF.ly2 >>$CIPFILE
echo TITLE.cnt=$TITLEIF.cnt >>$CIPFILE
echo TITLE.ly1=$TITLEIF.ly1 >>$CIPFILE
echo TITLE.n01=$TITLEIF.n01 >>$CIPFILE
echo TITLE.iyp=$TITLEIF.iyp >>$CIPFILE

if [ -f $FILES_LIST ]
then
	./sh_genlangdb/generate_lang_db.sh $MX $FILES_LIST $LANGDB $TEMP_PATH $CIPFILE $LOGFILE
else
	echo Input file $FILES_LIST is missing
fi
echo `date`