MX=$1
FILES_LIST=$2
OUTPUT=$3

cat $FILES_LIST | tr [A-Z] [a-z] | sort -u > $FILES_LIST.tmp
$MX seq=$FILES_LIST.tmp lw=99999 "pft=@pft/normalize.pft" now | sort -u > $OUTPUT 