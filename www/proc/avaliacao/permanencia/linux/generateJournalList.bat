# Param 1 issn
# Param 2 count

# export MX=$MX
# CPFILE
#
export MX=$1
export CPFILE=$2
export SCILISTA=$3

$MX cipar=$CPFILE TITLE lw=9999 "pft=if v50='C' then v100,'|',v400,'|',v68/ fi" now  > $SCILISTA

echo lista de revista gerada em $SCILISTA