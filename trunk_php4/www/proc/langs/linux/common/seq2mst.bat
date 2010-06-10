. $1
SEQ=$2
MST=$3
SPACE=$4

if [ ! -f $SEQ ]
then
    echo Missing $SEQ $0 $1 $2 $3 $4
else
    if [ "$SPACE" == "" ]
    then
      $MX seq=$SEQ create=$MST now -all
    else
       $MX "seq=$SEQ " create=$MST now -all
    fi
fi