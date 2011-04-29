. $1
SEQ=$2
MST=$3
SPACE=$4

if [ -f "$SEQ" ]
then
    if [ "$SPACE" == "" ]
    then
      $MX seq=$SEQ create=$MST now -all
    else
       $MX "seq=$SEQ " create=$MST now -all
    fi
else
    echo Missing $SEQ $0 $1 $2 $3 $4
fi