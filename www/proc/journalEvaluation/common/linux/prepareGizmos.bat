. $1

echo Tabelas de gizmo
$MX seq=$PATH_GZM/gizmoFreq.seq create=$PATH_GZM/gizmoFreq now -all
$MX "seq=$PATH_GZM/pipe2tab.seq " create=$PATH_GZM/pipe2tab now -all
$MX "seq=$PATH_GZM/tabEdboard.seq" create=$PATH_GZM/tabEdboard now -all
$MX "seq=$PATH_GZM/pattern.seq" create=$PATH_GZM/pattern now -all

#$MX "iso=$PATH_GZM/tab.iso" create=$PATH_GZM/tab now -all
$MX "seq=$PATH_GZM/tab.seq;" create=$PATH_GZM/tab now -all
$MX "seq=$PATH_GZM/tab2sep.seq " create=$PATH_GZM/tab2sep now -all
