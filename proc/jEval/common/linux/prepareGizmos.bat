. $1

echo Tabelas de gizmo

./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_GZM/country.seq $PATH_GZM/gizmoCountry SPACE
./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_GZM/gizmoFreq.seq $PATH_GZM/gizmoFreq
./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_GZM/pipe2tab.seq $GZM_PIPE2TAB SPACE
./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_GZM/tabEdboard.seq $PATH_GZM/tabEdboard



$MX $TITLE lw=9999 "pft=v400,'|',v100/" now > temp/je_issn.seq
$PATH_COMMON_SHELLS/seq2mst.bat $1 temp/je_issn.seq $GZM_ISSN
$MX $TITLE lw=9999 "pft=(v350/)" now > $TITLE_LANGS

$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_GZM/ot.seq $GZM_OT
$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_GZM/langs.seq $GZM_LANG
$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_GZM/doctopic.seq $GZM_DOCTOPIC

$MX $GZM_PIPE2TAB count=1 "proc='d*','a1{',v2,'{a2{',v1,'{'" create=$GZM_TAB2PIPE now -all
