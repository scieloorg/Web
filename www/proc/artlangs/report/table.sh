MX=$1
YEAR=$2
YEAR_LANG=$3
LANG=$4
LANGLABEL=$5

$MX null count=1 "pft=#,'$LANGLABEL'," now

$MX seq=$YEAR lw=9999 "pft=';',ref(['$YEAR_LANG']l(['$YEAR_LANG']s(v1,'$LANG')),v999)" now
