
dos2unix */*.sh

. ./shs/readconfig.sh

OPTIONAL_RESULT_FILE=$1




PROC_ID=`date '+%Y%m%d%H%M'`

PROCESSED_FILE=$PROCESSED_PATH/$PROC_ID.lst

if [ ! -d $PROCESSED_PATH ]
then
    mkdir -p $PROCESSED_PATH
fi
if [ ! -d $INPROC_PATH ]
then
    mkdir -p $INPROC_PATH
fi

if [ "@" == "@$OPTIONAL_RESULT_FILE" ]
then
    echo mv $RESULT_PATH $INPROC_PATH
    mv $RESULT_PATH/*.res $INPROC_PATH
    echo cat
    cat $INPROC_PATH/*.res | sort -u -r > $PROCESSED_FILE
    rm -rf $INPROC_PATH/*.res

else
    if [ -f $OPTIONAL_RESULT_FILE ]
    then
        PROCESSED_FILE=$OPTIONAL_RESULT_FILE
    fi
fi
echo Processing $PROCESSED_FILE
sh ./shs/main_manage_result.sh config.sh $PROCESSED_FILE
echo $0 done.