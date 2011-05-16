CONFIG=$1
PROC_ID=$2

. $CONFIG

if [ -d "$RESULT_PATH/../processed/$PROC_ID.old" ]
then
    echo moving files $RESULT_PATH/../processed/$PROC_ID.old/*.res to $RESULT_PATH
    mv $RESULT_PATH/../processed/$PROC_ID.old/*.res $RESULT_PATH
    echo deleting $RESULT_PATH/../processed
    rm -rf $RESULT_PATH/../processed
    echo moving $QUERYDB.* $QUERYDB.$PROC_ID
    mkdir -p $QUERYDB.$PROC_ID
    mv $QUERYDB.* to $QUERYDB.$PROC_ID
    echo moving $NOTFOUND.* to $QUERYDB.$PROC_ID
    mv $NOTFOUND.* $QUERYDB.$PROC_ID
fi

dos2unix *.sh
