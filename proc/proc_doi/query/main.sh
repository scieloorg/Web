dos2unix *.sh
dos2unix */*.sh

. config.sh

echo ARTIGO.*=$ARTIGO.*     >  $CIPFILE
echo QUERY.*=$QUERYDB.*     >> $CIPFILE
echo NOTFOUND.*=$NOTFOUND.* >> $CIPFILE


sh ./shs/caller.sh config.sh pid.txt