rem export PATH=$PATH:.
rem GeraGizmoSubjLANG
rem Parametro 1: subject database
rem Parametro 2: mfn
rem Parametro 3: title
rem Parametro 4: serarea
rem Parametro 5: temp


call batch/InformaLog.bat $0 x Gera Gizmo Subj LANG

$CISIS_DIR/mx $1 from=$2 count=1 lw=9999 "pft=(v2^c,'|',v2^v/)" now> $5/gizmo_subject.seq
$CISIS_DIR/mx seq=$5/gizmo_subject.seq create=$5/gizmo_subject now -all
$CISIS_DIR/mx $3 gizmo=$5/gizmo_subject,441 "fst='1 0 mpl,(v441/)'"  fullinv=$4
