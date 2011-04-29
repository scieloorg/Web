FILES_PATH=$1
FILENAME=$2

TEMP_FILENAME=$FILENAME.tmp

p=`pwd`

cd $FILES_PATH/pdf
find . -name "*.pdf" > $TEMP_FILENAME
cd $FILES_PATH/translation
find . -name "??_*.ht*" >> $TEMP_FILENAME


cat $TEMP_FILENAME | tr [A-Z] [a-z] | sort -u > $FILENAME

cd $p


