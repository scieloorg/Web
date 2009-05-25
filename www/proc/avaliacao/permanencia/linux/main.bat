# Param 1 issn
# Param 2 count

# export MX=$MX
# CPFILE
#
export MX=lindG4/mx
export CPFILE=avaliacao/permanencia/config/avaliacao.cip
export OUTPUT_PATH=/home/scielo/www/htdocs/teste/avaliacao/permanencia/data/
export rel=/teste/avaliacao/permanencia/data/
export SCILISTA=temp/avaliacao_permanencia_scilista.lst
export ISSUEQTD=3
export HTML_FILE=/home/scielo/www/htdocs/teste/avaliacao/permanencia/data/journals.htm
export JOURNAL_EDBOARD_HTML_PATH=/home/scielo/www/htdocs/revistas/
AFFLISTCOMPLETA=avaliacao/gizmo/affcompleta

echo Tabelas de gizmo
$MX seq=avaliacao/gizmo/gizmoFreq.seq create=avaliacao/gizmo/gizmoFreq now -all
$MX "seq=avaliacao/gizmo/pipe2tab.seq " create=avaliacao/gizmo/pipe2tab now -all
#$MX "iso=avaliacao/permanencia/linux/tab.iso" create=avaliacao/gizmo/tab now -all
$MX "seq=avaliacao/permanencia/linux/tab.seq;" create=avaliacao/gizmo/tab now -all
$MX "seq=avaliacao/permanencia/linux/tab2sep.seq " create=avaliacao/gizmo/tab2sep now -all
$MX "seq=avaliacao/gizmo/tabEdboard.seq" create=avaliacao/gizmo/tabEdboard now -all
$MX "seq=avaliacao/gizmo/pattern.seq" create=avaliacao/gizmo/pattern now -all


if [ -f temp/avaliacao_afiliacoes.txt ]
then
	rm temp/avaliacao_afiliacoes.txt
fi
if [ -f log/avaliacao_permanencia.log ]
then
	rm log/avaliacao_permanencia.log
fi


chmod  775 avaliacao/permanencia/linux/*.bat

if [ ! -d $OUTPUT_PATH ]
then
	mkdir -p $OUTPUT_PATH
fi

./avaliacao/permanencia/linux/generateJournalList.bat $MX $CPFILE $SCILISTA

vi $SCILISTA

more avaliacao/pft/html.00.pft > $HTML_FILE

# $MX null count=1 lw=9999 "pft='<p><a href=\"aff_list.txt\">Affiliation list to check</a></p>'" now >> $HTML_FILE


if [ -f temp/v70.seq ]
then 
	rm temp/v70.seq
fi


$MX "seq=$SCILISTA" lw=9999 "pft=if p(v3) then './avaliacao/permanencia/linux/getJournalAff.bat ',v2,' $ISSUEQTD $MX $CPFILE temp/v70.seq ',v3/ fi" now  > temp/avaliacao_aff.bat
chmod 775 temp/avaliacao_aff.bat
./temp/avaliacao_aff.bat
$MX seq=temp/v70.seq create=temp/v70 now -all
$MX temp/v70 fst=@avaliacao/fst/v70.fst fullinv=temp/v70

# gerar um gizmo incompleta (inst-city) para completa
$MX temp/v70 btell=0 "completa" lw=99999 "pft=@avaliacao/pft/aff_completa.pft" now | sort -u > temp/aff_completa.seq
$MX seq=temp/aff_completa.seq create=temp/aff_completa now -all
$MX temp/aff_completa fst=@avaliacao/fst/v70.fst fullinv=temp/aff_completa

$MX temp/v70 btell=0 "parcial" lw=99999 "proc='d970',ref(['temp/aff_completa']l(['temp/aff_completa']v2^*,v2^c,v2^s,v2^p),'a970{',v2,'{')" copy=temp/v70 now -all


echo JOurnals
$MX "seq=$SCILISTA" lw=9999 "pft=if p(v3) then './avaliacao/permanencia/linux/getJournalInfo.bat ',v2,' $ISSUEQTD $MX $CPFILE $OUTPUT_PATH ',v3,' $rel $HTML_FILE $JOURNAL_EDBOARD_HTML_PATH'/ fi" now  > temp/avaliacao_call.bat
chmod 775 temp/avaliacao_call.bat
./temp/avaliacao_call.bat 
# >log/avaliacao_geral.log


more avaliacao/pft/html.99.pft >> $HTML_FILE


ls -l $HTML_FILE