. $1

echo Tabelas de gizmo

if [ ! -d $PATH_GZM ]
then
    mkdir -p $PATH_GZM
fi

sh ./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_SEQ/country.seq $PATH_GZM/gizmoCountry SPACE
sh ./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_SEQ/ent2ans.seq $PATH_GZM/ent2ans
sh ./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_SEQ/gizmoFreq.seq $PATH_GZM/gizmoFreq
sh ./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_SEQ/pipe2tab.seq $GZM_PIPE2TAB SPACE
sh ./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_SEQ/dates.seq $DATEDB
$MX $DATEDB "fst=1 0 v1/" fullinv=$DATEDB

#$MX $GZM_PIPE2TAB count=1 "proc='d*','a1{',v2,'{a2{',v1,'{'" create=$GZM_TAB2PIPE now -all
