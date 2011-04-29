
MX=$1
DBLANG=$2
FILENAME=$3
PID=$4

$MX $DBLANG "text=$FILENAME" "proc='a880~$PID~a702~$FILENAME~'" copy=$DBLANG now -all 
