dos2unix *.sh
dos2unix */*.sh

. config.sh

echo ARTIGO.*=$ARTIGO.*     >  $CIPFILE
echo QUERY.*=$QUERYDB.*     >> $CIPFILE
echo NOTFOUND.*=$NOTFOUND.* >> $CIPFILE

PROC_ID=`date '+%Y%m%d%H%M'`


RESULTS_PROCESSED_PATH=$DATA_PATH/processed/$PROC_ID
RESULTS_PROCESSED_FILE=$RESULTS_PROCESSED_PATH.res

if [ ! -d $RESULTS_PROCESSED_PATH ]
then
    mkdir -p $RESULTS_PROCESSED_PATH
fi

curr=`pwd`
echo mv $RESULT_PATH/*.res $RESULTS_PROCESSED_PATH
mv $RESULT_PATH/*.res $RESULTS_PROCESSED_PATH
cd $RESULTS_PROCESSED_PATH
find . -name "*.res" > $RESULTS_PROCESSED_PATH/res_list.txt
echo > $RESULTS_PROCESSED_PATH/all_res.txt
$MX seq=$RESULTS_PROCESSED_PATH/res_list.txt lw=9999 "pft=if size(v1)>0 then 'cat ',v1*2,'>>$RESULTS_PROCESSED_PATH/all_res.txt',# fi" now >$RESULTS_PROCESSED_PATH/read_res.sh
sh $RESULTS_PROCESSED_PATH/read_res.sh
cat $RESULTS_PROCESSED_PATH/all_res.txt | sort -u -r > $RESULTS_PROCESSED_FILE
mv $RESULTS_PROCESSED_PATH $RESULTS_PROCESSED_PATH.old
cd $curr

echo Processing $RESULTS_PROCESSED_FILE
sh ./shs/main_useQueryResult.sh config.sh $RESULTS_PROCESSED_FILE