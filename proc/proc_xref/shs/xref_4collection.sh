COL=$1
PATH_DATA=$2
SIMULTANEO=$3

#nohup ./xref.sh $COL /bases/org.000/teste/b4c.$COL/bib4cit /bases/org.000/teste/art.$COL/artigo /bases/org.000/teste/art.$COL  >../log/$COL.`date '+%Y%m%d.%H%M%S'`.log&
./xref.sh $COL $PATH_DATA/b4c.$COL/bib4cit $PATH_DATA/art.$COL/artigo $PATH_DATA/art.$COL  $SIMULTANEO>../log/$COL.`date '+%Y%m%d.%H%M%S'`.log
