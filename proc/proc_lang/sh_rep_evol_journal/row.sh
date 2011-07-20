. config.sh

ISSN=$1
DB=$2
TITLE=$3

$MX null count=1 "pft=#,'$TITLE|$ISSN'" now
$MX seq=sh_rep_evol_journal/table lw=9000 "pft='sh sh_rep_evol_journal/cell.sh $ISSN',v1,' $DB'#" now> $TEMP_PATH/call_cell.sh

sh $TEMP_PATH/call_cell.sh