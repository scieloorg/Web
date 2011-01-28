BASES=$1
FILENAME=$2

p=`pwd`

cd $BASES/pdf
find . -name "*.pdf" > $FILENAME
cd $BASES/translation
find . -name "??_*.ht*" >> $FILENAME

cd $p


