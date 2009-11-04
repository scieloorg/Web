. $1
SEQ=$2
MST=$3
SPACE=$4

if [ "$SPACE" == "" ]
then
  $MX seq=$SEQ create=$MST now -all
else
   $MX "seq=$SEQ " create=$MST now -all
fi
