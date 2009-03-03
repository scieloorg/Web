

export SCILIL_VL_list=$1
export SCILIL_VL_cipar_file=$2
export SCILIL_VL_LIMITDATE=$3
export SCILIL_VL_ISSN=$4
export SCILIL_VL_ISSUEID=$5
export SCILIL_VL_ISSUEPID=$6
export SCILIL_VL_PUBDATE=$7


$SCILIL_MX cipar=$SCILIL_VL_cipar_file null count=1 lw=9999 "proc='a35{$SCILIL_VL_ISSN{a882{$SCILIL_VL_ISSUEID{a880{$SCILIL_VL_ISSUEPID{a9065{$SCILIL_VL_LIMITDATE{a65{$SCILIL_VL_PUBDATE{'" "pft=@scielo2lilacs/pft/list.pft" now >> $SCILIL_VL_list

