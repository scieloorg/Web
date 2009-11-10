. $1

echo Tabelas de gizmo

./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_GZM/gizmoFreq.seq $PATH_GZM/gizmoFreq
./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_GZM/pipe2tab.seq $PATH_GZM/pipe2tab SPACE
./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_GZM/tabEdboard.seq $PATH_GZM/tabEdboard
./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_GZM/pipe2tab.seq $GZM_2TAB SPACE
./$PATH_COMMON_SHELLS/seq2mst.bat $1 $PATH_GZM/country.seq $PATH_GZM/gizmoCountry SPACE


./$PATH_COMMON_SHELLS/generateGizmos.bat $1