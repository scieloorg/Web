COL=$1
PATH_DATA=$2

#nohup ./xref_query.sh $COL /bases/org.000/teste/b4c.$COL/bib4cit /bases/org.000/teste/art.$COL/artigo /bases/org.000/teste/art.$COL  >../log/$COL.`date '+%Y%m%d.%H%M%S'`.log&
nohup ./xref_query.sh $COL $PATH_DATA/b4c.$COL/bib4cit $PATH_DATA/art.$COL/artigo $PATH_DATA/art.$COL  >../log/$COL.`date '+%Y%m%d.%H%M%S'`.log&
